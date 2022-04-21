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
logApiPrint(
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
