
import 'package:flutter/material.dart';
import 'package:http/http.dart';

/// ==================================================================================/
/// HTTP CLIENT BASE =================================================================/
/// ==================================================================================/
///
/// Base HTTP client to use throughout application. Based off [BaseClient] allowing us
/// to use it in place of any [http.Client] while only overriding the methods we're
/// interested in.
///
/// Out of the box, this doesn't do much special past logging requests but it's good
/// practice to use this to allow for environment config, custom auth, throttling, etc.
/// much easier down the line.
///
class HttpClientBase extends BaseClient {
  HttpClientBase(this.delegate);

  final Client delegate;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    _logRequest(request);
    return delegate.send(request);
  }

  @override
  void close() => delegate.close();

  void _logRequest(BaseRequest request) {
    debugPrint(request.toString());
  }
}
