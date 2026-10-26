#!/usr/bin/env python3
"""
Vault database credential fetcher for Python applications.
Demonstrates fetching dynamic credentials and connecting to PostgreSQL.
"""

import hvac
import psycopg2
from contextlib import contextmanager
import time
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class VaultDatabaseClient:
    """
    Manages database connections using Vault-generated credentials.
    Handles credential fetching, renewal, and reconnection.
    """

    def __init__(self, vault_addr: str, vault_token: str, role: str, db_host: str, db_name: str):
        # Initialize Vault client
        self.client = hvac.Client(url=vault_addr, token=vault_token)
        self.role = role
        self.db_host = db_host
        self.db_name = db_name
        self.lease_id = None
        self.credentials = None
        self.lease_duration = 0
        self.lease_obtained_at = 0

    def fetch_credentials(self) -> dict:
        """
        Fetch new database credentials from Vault.
        Returns dict with username and password.
        """
        # Read credentials from the database secrets engine
        response = self.client.secrets.database.generate_credentials(
            name=self.role,
            mount_point="database"
        )

        # Store lease information for renewal
        self.lease_id = response["lease_id"]
        self.lease_duration = response["lease_duration"]
        self.lease_obtained_at = time.time()

        self.credentials = {
            "username": response["data"]["username"],
            "password": response["data"]["password"]
        }

        logger.info(
            f"Fetched credentials for role {self.role}, "
            f"lease duration: {self.lease_duration}s"
        )

        return self.credentials

    def should_renew(self, threshold_seconds: int = 300) -> bool:
        """
        Check if credentials should be renewed.
        Returns True if less than threshold_seconds remain on the lease.
        """
        if not self.lease_obtained_at:
            return True

        elapsed = time.time() - self.lease_obtained_at
        remaining = self.lease_duration - elapsed

        return remaining < threshold_seconds

    def renew_credentials(self) -> bool:
        """
        Renew the current lease.
        Returns True if renewal succeeded, False otherwise.
        """
        if not self.lease_id:
            logger.warning("No lease to renew, fetching new credentials")
            self.fetch_credentials()
            return True

        try:
            response = self.client.sys.renew_lease(
                lease_id=self.lease_id
            )
            self.lease_duration = response["lease_duration"]
            self.lease_obtained_at = time.time()
            logger.info(f"Renewed lease, new duration: {self.lease_duration}s")
            return True
        except hvac.exceptions.InvalidRequest:
            # Lease expired or invalid, fetch new credentials
            logger.warning("Lease renewal failed, fetching new credentials")
            self.fetch_credentials()
            return True

    def revoke_credentials(self):
        """
        Revoke current credentials when shutting down.
        Good practice to clean up credentials you no longer need.
        """
        if self.lease_id:
            try:
                self.client.sys.revoke_lease(lease_id=self.lease_id)
                logger.info(f"Revoked lease {self.lease_id}")
            except Exception as e:
                logger.error(f"Failed to revoke lease: {e}")

    @contextmanager
    def get_connection(self):
        """
        Context manager that provides a database connection.
        Handles credential refresh if needed.
        """
        # Renew or fetch credentials if needed
        if self.should_renew():
            if self.lease_id:
                self.renew_credentials()
            else:
                self.fetch_credentials()

        # Create connection with current credentials
        conn = psycopg2.connect(
            host=self.db_host,
            database=self.db_name,
            user=self.credentials["username"],
            password=self.credentials["password"],
            sslmode="require"
        )

        try:
            yield conn
        finally:
            conn.close()
