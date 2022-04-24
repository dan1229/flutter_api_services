# Flutter API Services

![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)

![Analyze](https://github.com/dan1229/flutter_api_services/actions/workflows/analyze.yml/badge.svg)
![Test](https://github.com/dan1229/flutter_api_services/actions/workflows/test.yml/badge.svg)
[![codecov](https://codecov.io/gh/dan1229/flutter_api_services/branch/main/graph/badge.svg?token=4WK2ND8R75)](https://codecov.io/gh/dan1229/flutter_api_services)

#### By: [Daniel Nazarian](https://danielnazarian) 🐧👹

##### Contact me at <dnaz@danielnazarian.com>

-------------------------------------------------------

HTTP services for Flutter/Dart. Includes templates, helper methods, types and more to help
interaction with external services of any sort.

Currently supporting:

- Django REST
- Django Graph QL (coming soon)

## Features

Support common HTTP REST methods, authentication, serialization, error handling and more to increase
stability and reduce boilerplate. Declare a hardened and efficient API in as little as one simple
declaration.

### Classes Available

- Django Auth Service
    - Login
    - Signup
- Django Create Service
    - POST
    - PATCH (coming soon)
    - DELETE (coming soon)
- Django Results Service
    - GET - List
    - GET - Retrieve
    - GET - Next/Prev
- HTTP Client
- APIResponse

## Getting started

This package **is not** on pub.dev so to use the package declare it like so in your `pubspec.yaml`

```yaml
flutter_api_services:
  git:
    url: https://github.com/dan1229/flutter_api_services.git
    ref: main # branch name
```

Then run `flutter pub get` to download and install it. Then, you're ready to get using!

### Versioning

Versioning for Git packages in Flutter isn't exactly the best - to work around this, each official
release will need to be made into a branch on GitHub, then you can reference that branch. The format
for these branches is:
`version/X.X.X`

## Usage

To use, simple create your API classes as children of the included templates. To create
a `DjangoResultsService` API for example you might do something like the following:

```dart
class PostsApi extends DjangoResultsService<Post> {
  PostsApi({
    required Client client,
  }) : super(client: client,
      uriApiBase: Uri.parse("https://example.com/posts/"),
      fromJson: (Map<String, dynamic> json) => Post.fromJson(json));
}
```

Now, instances of `PostsApi` will have access to all the methods and functionality
of `DjangoResultsService` including `list`, `retrieve`, `next`, `prev`, etc.

To create a `DjangoCreateService` API for example you might do something like the following:

```darta
import 'package:http/http.dart';

class EmailApi extends DjangoCreateService<Email> {
  EmailApi({
    required Client client,
  }) : super(client: client,
      uriApiBase: Uri.parse("https://example.com/email/"),
      fromJson: (Map<String, dynamic> json) => Email.fromJson(json));


  Future<ApiResponse<dynamic>> sendEmail({required String message, String? subject}) {
    return super.postApi(
        body: <String, dynamic>{"subject": subject, "message": message}, authenticated: false);
  }
}
```

## Examples

TODO

- `examples` folder
    - just show each template

## Tests

To run tests manually simply run:

```bash
flutter test
```

More simply, to run tests and generate coverage report simply run `./scripts/test_coverage.sh`.

## Deployment

To deploy/update simply run the GitHub Action for `deploy` - it will prompt you for a version number
and create a branch with the most recent commit. It will also create an 'official' GitHub release to
give another way to find it. sNote, it will use said commits message as the release description.

-------------------------------------------------------

##### [https://danielnazarian.com](https://danielnazarian.com)

##### Copyright 2022 © Daniel Nazarian.
