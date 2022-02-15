# Flutter API Services

#### By: [Daniel Nazarian](https://danielnazarian) 🐧👹

##### Contact me at <dnaz@danielnazarian.com>

-------------------------------------------------------

Services for HTTP services for Flutter/Dart. Includes templates and support

Currently supporting:

- Django REST

## Features

Support common HTTP REST methods, authentication, serialization, error handling and more to increase
stability and reduce boilerplate. Declare a hardened and efficient API in as little as one simple
declaration.

## Getting started

This package **is not** on pub.dev so to use the package declare it like so in your `pubspec.yaml`

```yaml
flutter_api_services:
  git:
    url: https://github.com/dan1229/flutter_api_services.git
    ref: main # branch name
```

Then run `flutter pub get` to download and install it. Then, you're ready to get using!

## Usage

To use, simple create your API classes as children of the included templates. To create
a `DjangoResultsService` API for example you might do something like the following:

```dart
class PostsApi extends DjangoResultsService< Post > {
  PostsApi({
    required Client client,
  }) : super(
      client: client,
      uriApiBase: Uri.parse("https://danielnazarian.com/api/posts/"),
      fromJson: (Map< String, dynamic> json) => Post.fromJson(json));
}
```

To create a `DjangoCreateService` API for example you might do something like the following:

```dart
import 'package:http/http.dart';

class MessageApi extends CreateService<Message> {
  MessageApi({
    required Client client,
  }) : super(client: client,
      uriApiBase: Uri.parse("https://danielnazarian.com/api/messages/"),
      fromJson: (Map<String, dynamic> json) => Message.fromJson(json));


  Future<Map<String, dynamic>> sendMessage({required String message}) {
    return super.postApi(body: <String, dynamic>{"message": message});
  }
}
```

TODO
- `examples` folder
    - just show each template


-------------------------------------------------------

##### [https://danielnazarian.com](https://danielnazarian.com)

##### Copyright 2022 © Daniel Nazarian.
