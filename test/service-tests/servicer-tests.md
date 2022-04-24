# Service Tests

These service tests are meant to test the `lib/services` module.

Since these are just client side APIs, they're really just intended to test our implementation of
the APIs. Even more, since many of our APIs are implemented via packages -
i.e., [Flutter API Tools](https://github.com/dan1229/flutter_api_services/) - we are testing really
syntax, overrides, etc.

To say - you probably won't have a lot of these tests.

If your app has a lot of external services, you will probably use these as well to
avoid [flaky tests](https://www.jetbrains.com/teamcity/ci-cd-guide/concepts/flaky-tests/). For that
reason, I've included some 'good quality' tests to base your test structure on in the event you want
to write tests for said services (or just up your coverage).

## _values.dart Files

These files are meant to standardize test values across inputs, requests, responses, etc.

Again, since most of these are handled by packages, and even then determined by the backend, we're
really only testing small parts of our implementation.

For external services, you could use this to codify your interpretation of said service.