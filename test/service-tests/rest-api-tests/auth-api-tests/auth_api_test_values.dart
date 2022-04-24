import 'dart:convert';

import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:http/src/response.dart';

// ====================================================
// AUTH API TEST VALUES ===============================
// ====================================================

class AuthApiTestValues {
  // emails
  final String emailValid = 'example@example.com';
  final String emailInvalid = 'invalid';
  final String email500Error = '500error@example.com';

  // passwords
  final String passwordValid = 'password';
  final String passwordInvalid = '1';
  final String password500Error = 'password';

  //
  // LOGIN - requests
  //
  Map<String, dynamic> requestLoginBase(String email, String password) {
    return <String, dynamic>{
      "email": email,
      "password": password,
    };
  }

  Map<String, dynamic> requestLoginValid() {
    return requestLoginBase(emailValid, passwordValid);
  }

  Map<String, dynamic> requestLoginInvalid() {
    return requestLoginBase(emailInvalid, passwordInvalid);
  }

  Map<String, dynamic> requestLogin500Error() {
    return requestLoginBase(email500Error, password500Error);
  }

  //
  // LOGIN - responses
  //
  ApiResponse<dynamic> responseDataLoginValid = ApiResponseSuccess<dynamic>(message: "Successful login.", details: <String, dynamic>{
    "id": "id",
    "email": "danielnazarian@outlook.com",
    "first_name": "Daniel",
    "last_name": "Nazarian",
    "stringify": "Daniel Nazarian",
    "is_staff": true,
    "token": "token"
  });
  Response responseLoginValid() {
    return Response(json.encode(responseDataLoginValid.toMap()), 200);
  }

  ApiResponse<dynamic> responseDataLoginInvalid = ApiResponseError<dynamic>(message: "Invalid login.");
  Response responseLoginInvalid() {
    return Response(json.encode(responseDataLoginInvalid.toMap()), 400);
  }

  ApiResponse<dynamic> responseDataLogin500Error = ApiResponseError<dynamic>(message: "Login 500 error.");
  Response responseLogin500Error() {
    return Response(json.encode(responseDataLogin500Error.toMap()), 500);
  }


  //
  // SIGNUP - requests
  //
  Map<String, dynamic> requestSignupBase(String email, String password) {
    return <String, dynamic>{
      "email": email,
      "password": password,
    };
  }

  Map<String, dynamic> requestSignupValid() {
    return requestSignupBase(emailValid, passwordValid);
  }

  Map<String, dynamic> requestSignupInvalid() {
    return requestSignupBase(emailInvalid, passwordInvalid);
  }

  Map<String, dynamic> requestSignup500Error() {
    return requestSignupBase(email500Error, password500Error);
  }


  //
  // SIGNUP - responses
  //
  Map<String, dynamic> responseDataSignupValid = <String, dynamic>{
    "message": "Successful login",
    "results": {
      "id": "id",
      "email": "danielnazarian@outlook.com",
      "first_name": "Daniel",
      "last_name": "Nazarian",
      "stringify": "Daniel Nazarian",
      "is_staff": true,
      "token": "token"
    }
  };
  Response responseSignupValid() {
    return Response(json.encode(responseDataSignupValid), 200);
  }

  ApiResponse<dynamic> responseDataSignupInvalid = ApiResponseError<dynamic>(message: "Invalid signup.");
  Response responseSignupInvalid() {
    return Response(json.encode(responseDataSignupInvalid.toMap()), 400);
  }

  ApiResponse<dynamic> responseDataSignup500Error = ApiResponseError<dynamic>(message: "Signup 500 error.");
  Response responseSignup500Error() {
    return Response(json.encode(responseDataSignup500Error.toMap()), 500);
  }
}
