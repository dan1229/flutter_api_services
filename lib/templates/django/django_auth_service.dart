
import 'dart:convert';

import 'package:flutter_api_services/api_helpers.dart';
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
  Future<Map<String, dynamic>> postLoginApi({required String email, required String password}) async {
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
          return defaultSuccessMap(message: "Successfully logged in.", extras: <String, dynamic>{'token': decoded['token'], 'decoded': decoded});
        case 400: // bad request
          return defaultErrorMap(message: decoded['error']);
        case 500: // server error
          return defaultErrorMap(message: decoded['error']);
        default: // who knows
          return defaultErrorMap();
      }
    } catch (e) {
      logApiPrint("AuthService.postLoginApi: error\n${e.toString()}", tag: "EXP");
      return defaultErrorMap();
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
  Future<Map<String, dynamic>> postSignupApi({required String email, required String password}) async {
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
          return defaultSuccessMap(message: "Successfully registered.", extras: <String, dynamic>{'token': decoded['token'], 'decoded': decoded});
        case 201: // success
          return defaultSuccessMap(message: "Successfully registered.", extras: <String, dynamic>{'token': decoded['token'], 'decoded': decoded});
        case 400: // bad request
          return defaultErrorMap(message: getErrorMessage(decoded));
        case 500: // server error
          return defaultErrorMap(message: getErrorMessage(decoded));
        default: // who knows
          return defaultErrorMap();
      }
    } catch (e) {
      logApiPrint("AuthService.postSignupApi: error\n${e.toString()}", tag: "EXP");
      return defaultErrorMap();
    }
  }

  Uri _uriSignup() {
    return Uri.parse("$uriApiBase/signup/");
  }

  String? getErrorMessage(Map<String, dynamic> decoded) {
    if (decoded['error'] != null) {
      return decoded['error'];
    } else if (decoded['email'] != null) {
      return decoded['email'];
    } else if (decoded['non_field_errors'] != null) {
      return decoded['non_field_errors'][0];
    } else {
      return null;
    }
  }
}
