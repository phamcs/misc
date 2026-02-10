
# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
 
## [Released] - 2025-10-03
 
Here we write upgrading notes for brands. It's a team effort to make them as
straightforward as possible.

## [1.5.0] - 2026-02-07
 
### Added
   Monitoring to apps-server role
### Changed
  - Move portainer to common role
  - Update app-server role
### Fixed
  - Update to use variables

## [1.4.0] - 2026-02-05
 
### Added
   Dragonfly role
### Changed
  - Add dragonfly role
  - Update dragonfly role
  - Update app-server role
### Fixed
  - Update to use variables

## [1.3.0] - 2025-10-25
 
### Added
   Harbor role
### Changed
  - Add harbor role
  - Update artifactory role
  - Update app-server role
### Fixed
  - Update to use variables

## [1.2.0] - 2025-10-05
 
### Added
   Registry role
### Changed
  - Refactor registry role with artifactory using packages install method (due to hardware incompatible with docker)
  - Update artifactory task
### Fixed
   Registry role

## [1.1.0] - 2025-10-03
 
### Added
   Artifactory role
### Changed
  - Split artifactory from app-server to its own role
  - Update artifactory role
  - Update common role
### Fixed
   Common

## [1.0.0] - 2025-10-03
 
### Added
   CHANGELOG
### Changed
  - Announced deprecated registry roles in favor Harbor
  - Update vault & grafana to use copy files for config
  - Renamed influxdb2 to influxdb
### Fixed
   README


docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token eyJhIjoiOWEyNmQwY2I4NDM4OTRhODY1NmFjZDUwNmYyZWJlOWMiLCJ0IjoiNzE2NDI4MDMtZGRjZi00ODNkLTk1Y2EtZGZjOTY0NmQ3Mjk1IiwicyI6Ik1XVXdOV1UzWTJZdE1ESTFPUzAwTkdFNUxUaGxZVE10TnpCbE9EZGpZbUUzWVRJMSJ9