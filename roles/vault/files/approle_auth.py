#!/usr/bin/env python3
"""
AppRole authentication example for HashiCorp Vault.
Demonstrates secure secret retrieval using role_id and secret_id.
"""

import hvac
import os

def authenticate_with_approle():
    """
    Authenticate to Vault using AppRole and retrieve a secret.
    Role ID should be in config, Secret ID should be injected at runtime.
    """
    # Initialize the Vault client
    client = hvac.Client(url=os.environ.get('VAULT_ADDR', 'http://localhost:8200'))

    # Retrieve credentials from environment
    # Role ID is typically embedded in application config
    # Secret ID should be injected via secure mechanism (Kubernetes secret, etc.)
    role_id = os.environ['VAULT_ROLE_ID']
    secret_id = os.environ['VAULT_SECRET_ID']

    # Authenticate using AppRole
    response = client.auth.approle.login(
        role_id=role_id,
        secret_id=secret_id
    )

    # The client is now authenticated
    print(f"Successfully authenticated. Token accessor: {response['auth']['accessor']}")

    # Read a secret using the authenticated client
    secret = client.secrets.kv.v2.read_secret_version(
        path='my-app/config',
        mount_point='secret'
    )

    return secret['data']['data']

if __name__ == '__main__':
    config = authenticate_with_approle()
    print(f"Retrieved configuration: {config}")