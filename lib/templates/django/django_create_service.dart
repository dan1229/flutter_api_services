
import 'dart:convert';

import 'package:flutter_api_services/src/api_helpers.dart';
import 'package:flutter_api_services/src/response_types.dart';
import 'package:http/http.dart' as http;

/// ===============================================================================/
/// DJANGO CREATE SERVICE =========================================================/
/// ===============================================================================/
///
/// This template is for any Django creation/update based APIs.
///
/// This includes the following API handlers:
/// - post API
/// TODO
/// - patch API
/// - delete API
///
class DjangoCreateService<T> {
  // input
  final http.Client client;
  final Uri uriApiBase; // NOTE: this almost definitely should end in a '/'
  final String? token; // Optional, if API requires auth
  final Function? fromJson; // This is the fromJson constructor on the model (T). Dart doesn't support generic constructors sadly (yet?)

  // properties - custom
  // TODO how to have this with const constructor?
  // bool updating = false;

  const DjangoCreateService({
    required this.client,
    required this.uriApiBase,
    this.fromJson,
    this.token,
  });

  /// =============================================================================/
  /// POST API ====================================================================/
  /// =============================================================================/
  ///
  /// Generic function to call POST API
  ///
  /// @[PARAM]
  /// Map<String, dynamic> body   - Body to include in request
  /// bool authenticated          - Whether or not to authenticate request
  /// Function? onSuccess         - Optional callback function on successful API call
  /// Function? onError           - Optional callback function on unsuccessful API call
  ///
  /// @[RETURN]
  /// ApiResponse           - error or success based on result(s)
  ///
  Future<ApiResponse> postApi(
      {required Map<String, dynamic> body, bool authenticated = false, Function? onSuccess, Function? onError}) async {

    // handle auth
    Map<String, String> headers;
    if (authenticated) {
      headers = headerTokenAuth(token: token ?? "NO TOKEN PROVIDED");
    } else {
      headers = headerNoAuth();
    }

    // send HTTP request to endpoint
    http.Response response;
    String bodyStr = bodyGeneric(map: body);
    try {
      response = await client.post(uriApiBase, headers: headers, body: bodyStr);
    } catch (e) {
      logApiPrint("CreateService.postApi<${T.toString()}>: HTTP error\n${e.toString()}", tag: "EXP");
      return ApiResponseError();
    }

    // deserialize json
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      logApiPrint("CreateService.postApi<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
      return ApiResponseError();
    }

    // process response
    String message = 'login error.';
    if (decoded.containsKey('message')) {
      message = decoded['message'];
    }
    if (response.statusCode == 200) {
      // 200 -> valid
      if (onSuccess != null) {
        onSuccess();
      }
      return ApiResponseSuccess(message: message);
    } else if (response.statusCode == 401) {
      // 401 -> unauthorized
      if (onError != null) {
        onError();
      }
      return ApiResponseError(message: decoded['detail']);
    } else {
      // 400, 500 and others -> error
      if (onError != null) {
        onError();
      }
      return ApiResponseError(message: message);
    }
  }
}
