
import 'dart:convert';

import 'package:flutter_api_services/src/api_helpers.dart';
import 'package:flutter_api_services/src/response_types.dart';
import 'package:http/http.dart';

// ===============================================================================/
// DJANGO AUTH SERVICE ===========================================================/
// ===============================================================================/

class DjangoAuthService {
  final Client client;
  final Uri uriApiBase;

  DjangoAuthService({
    required this.client,
    required this.uriApiBase,
  });

  /// ======================= //
  ///
  /// LOGIN
  ///
  /// callLoginApi
  /// @[PARAM]
  /// String email                     - email to login with
  /// String password                  - password to login with
  /// @[RETURN]
  /// Map<String, dynamic>             - map containing response info/results
  ///
  Future<ApiResponse> postLoginApi({required String email, required String password}) async {
    Uri uri = _uriLogin();
    Map<String, String> headers = headerNoAuth();
    String body = bodyGeneric(map: <String, String>{
      'email': email,
      'password': password,
    });

    try {
      Response response = await client.post(uri, headers: headers, body: body);
      Map<String, dynamic> decoded = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200: // success
          return ApiResponseSuccess(message: "Successfully logged in.", results: <String, dynamic>{'token': decoded['token'], 'decoded': decoded});
        case 400: // bad request
          return ApiResponseError(message: decoded['message']);
        case 500: // server error
          return ApiResponseError(message: decoded['message']);
        default: // who knows
          return ApiResponseError();
      }
    } catch (e) {
      logApiPrint("AuthService.postLoginApi: error\n${e.toString()}", tag: "EXP");
      return ApiResponseError();
    }
  }

  Uri _uriLogin() {
    return Uri.parse("$uriApiBase/login/");
  }

  /// ======================= //
  ///
  /// SIGN UP
  ///
  /// callSignupApi
  /// @[PARAM]
  /// String email                     - email to login with
  /// String password                  - password to login with
  /// @[RETURN]
  /// Map<String, dynamic>             - map containing response info/results
  ///
  Future<ApiResponse> postSignupApi({required String email, required String password}) async {
    Uri uri = _uriSignup();
    Map<String, String> headers = headerNoAuth();
    String body = bodyGeneric(map: <String, String>{
      'email': email,
      'password': password,
    });

    try {
      Response response = await client.post(uri, headers: headers, body: body);
      Map<String, dynamic> decoded = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200: // success
          return ApiResponseSuccess(message: decoded['message'], results: <String, dynamic>{'token': decoded['token'], 'decoded': decoded});
        case 201: // success
          return ApiResponseSuccess(message: decoded['message'], results: <String, dynamic>{'token': decoded['token'], 'decoded': decoded});
        case 400: // bad request
          return ApiResponseError(message: getErrorMessage(decoded));
        case 500: // server error
          return ApiResponseError(message: getErrorMessage(decoded));
        default: // who knows
          return ApiResponseError();
      }
    } catch (e) {
      logApiPrint("AuthService.postSignupApi: error\n${e.toString()}", tag: "EXP");
      return ApiResponseError();
    }
  }

  Uri _uriSignup() {
    return Uri.parse("$uriApiBase/signup/");
  }

  String getErrorMessage(Map<String, dynamic> decoded) {
    if (decoded['error'] != null) {
      return decoded['error'];
    } else if (decoded['message'] != null) {
      return decoded['message'];
    } else if (decoded['email'] != null) {
      return decoded['email'];
    } else if (decoded['non_field_errors'] != null) {
      return decoded['non_field_errors'][0];
    } else {
      return "Error. Please try again later.";
    }
  }
}
