library flutter_api_services;
import 'dart:convert';

import 'package:flutter/material.dart';

/// ============================================================================/
/// API HELPERS ================================================================/
/// ============================================================================/


///
/// LOGGING ====================================================================/
///
/// Default logging function. Will not print in production and offers some nice
/// formatting to make more noticeable.
///
logPrint(
    String msg, {
      String tag = "INFO",
      String sym = "*",
    }) {
  debugPrint("========================================");
  debugPrint("[ $sym $tag $sym ]\n$msg");
  debugPrint("========================================");
}



///
/// API HEADER
///
/// Create appropriate http header
///
/// @[PARAM]
/// String token            - user token to add to header
/// String contentType      - specific content type to use
///
/// @[RETURN]
/// Map<String, String>     - headers to add to call
///
Map<String, String> headerTokenAuth({required String token, String contentType = "application/json"}) {
  return <String, String>{
    "Content-Type": contentType,
    "Accept": "application/json",
    "Authorization": "Token $token",
  };
}

Map<String, String> headerNoAuth({String contentType = "application/json"}) {
  return <String, String>{
    "Content-Type": contentType,
    "Accept": "application/json",
  };
}

///
/// API BODY
///
/// Create appropriate http body
///
/// @[PARAM]
/// Map map           - map to turn into body
///
/// @[RETURN]
/// String            - body in JSON encoded string form
///
String bodyGeneric({required Map<String, dynamic> map}) {
  return json.encode(map);
}

///
/// API RESPONSE
///
/// These functions are used to standardize api/service responses. They are not
/// required to use but help greatly in standardizing responses.
///
/// @[PARAM]
/// String [message]          - the error/detail message itself
/// Map [extras]              - map to add to default options, this is how you add extra data i.e., the object retrieved in the API call
/// @[RETURN]
/// Map<String, dynamic>    - standardized response map
/// - String [message]        - error/success message given
/// - bool [error]            - whether or not call was successful
/// - dynamic [extras]        - any 'extras' passed to function
///
Map<String, dynamic> defaultErrorMap({
  String? message,
  Map<String, dynamic>? extras,
}) {
  return <String, dynamic>{
    ...<String, dynamic>{
      'message': defaultErrorMessage(message: message),
      'error': true,
    },
    ...extras ?? <String, dynamic>{}
  };
}

Map<String, dynamic> defaultSuccessMap({
  String? message,
  Map<String, dynamic>? extras,
}) {
  return <String, dynamic>{
    ...<String, dynamic>{
      'message': defaultSuccessMessage(message: message),
      'error': false,
    },
    ...extras ?? <String, dynamic>{}
  };
}

///
/// These functions simply standardize the error strings themselves
///
String defaultErrorMessage({String? message}) {
  message ??= 'Please try again later.';
  return "Error. $message";
}

String defaultSuccessMessage({String? message}) {
  message ??= '';
  return "Success! $message";
}
