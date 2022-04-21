
import 'package:flutter_api_services/api_helpers.dart';
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
  HttpClientBase({required this.client, this.logRequests = true});

  final Client client;
  final bool logRequests;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    if (logRequests) {
      _logRequest(request);
    }
    return client.send(request).timeout(const Duration(seconds: 10), onTimeout: () {
      throw Exception("Timeout error.");
    });
  }

  @override
  void close() => client.close();

  void _logRequest(BaseRequest request) {
    logApiPrint(request.toString(), tag: "REQ");
  }
}
