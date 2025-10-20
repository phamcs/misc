
# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
 
## [Released] - 2025-10-03
 
Here we write upgrading notes for brands. It's a team effort to make them as
straightforward as possible.

## [1.3.0] - 2025-102-5
 
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
