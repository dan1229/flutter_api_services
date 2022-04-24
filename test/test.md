# Test.md

These are the Flutter tests for this project.

## Running

To run tests manually simply run:

```bash
flutter test --dart-define='ENVIRONMENT=testing' --dart-define='URI_BASE=http://127.0.0.1:8000'
```

More simply, to run tests and generate coverage report simply run `./scripts/test_coverage.sh`.


## Mock Client

Fake client for requests - use this for tests to
avoid  [flaky tests](https://www.jetbrains.com/teamcity/ci-cd-guide/concepts/flaky-tests/) when you
have to have function calls.