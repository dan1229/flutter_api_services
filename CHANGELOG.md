# CHANGELOG for Flutter API Services

#### By: [Daniel Nazarian](https://danielnazarian) 🐧👹

##### Contact me at <dnaz@danielnazarian.com>

-------------------------------------------------------

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


-------------------------------------------------------

## [Released]

### [0.2.0] - 2025-02-03
- Update Flutter version, no more Flutter 2.X supporrt
- Update http dependency


### [0.1.0] - 2022-04-24
- Auth API cleanup
- Response Type standardization
    - Generic types
- GitHub Actions (CI/CD)
    - Badges too ofc
- TESTS and INFRASTRUCTURE
    - Auth API
    - Results API
    - Create API
    

### [0.0.5] - 2022-04-23
- More public functions


### [0.0.4] - 2022-04-21
- Next/Prev pagination function fixes
- Full pagination support


### [0.0.3] - 2022-04-21
- API handler update/fixes
- Doc improvements
- Logging for HTTP requests is optional
- Response Type classes!


### [0.0.2] - 2022-02-28
- Updated API logging


### [0.0.1] - 2022-02-03
- Initial release!
- Templates included:
    - Django Results Service
    - Django Create Service
    - Django Auth Service
- Helpers
- Base HTTP Client

-------------------------------------------------------
## [Unreleased]
-------------------------------------------------------

### TODO

#### misc / later

graphql?

other backends?

- rust?
- node?

------

#### docs

docs folder
- usage
    - each template
- examples folder?

improve doc strings
- move under function header?
- add to params https://dart.dev/guides/language/effective-dart/documentation

------

#### create api service

validate service works as is?

new methods
- add patch
- add delete

------

#### tests

get coverage up!

------

### 1.1.1

coverage support
- coverage ignore
- // coverage:ignore-file

Improve tests!
- add more asserts to existing check
    - auth api should use '400' instead of 'invalid' test?
- add checks for class props
    - results class
        - page count
        - next/prev/count etc.

### [0.1.1] - 2022-MM-DD
- Improve tests
- Coverage improvements/tweaks

-------------------------------------------------------

##### [https://danielnazarian.com](https://danielnazarian.com)

##### Copyright 2022 © Daniel Nazarian.
