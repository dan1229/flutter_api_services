import 'dart:convert';

import 'package:flutter_api_services/api_helpers.dart';
import 'package:flutter_api_services/templates/django/json/django_paginated_api_json.dart';
import 'package:http/http.dart' as http;

/// ===============================================================================/
/// DJANGO RESULTS SERVICE ========================================================/
/// ===============================================================================/
///
/// This template is for any Django results based API results. It uses the paginated
/// API JSON to parse list APIs and handle common functionality like calling the API,
/// pagination, and common helper functions.
///
/// This includes the following API handlers:
/// - List API
///   - Next
///   - Prev
/// - Details API
///
class DjangoResultsService<T> {
  // input
  http.Client client;
  Function fromJson; // This is the fromJson constructor on the model (T). Dart doesn't support generic constructors sadly (yet?)
  Uri uriApiBase; // NOTE: this almost definitely should end in a '/'
  String? token; // Optional, if API requires auth

  // properties - from API
  int? count;
  String? next;
  String? previous;
  List<T>? list = <T>[];
  T? resultDetails;

  // properties - custom
  bool updating = false;

  DjangoResultsService({
    required this.client,
    required this.uriApiBase,
    required this.fromJson,
    this.token,
    this.count,
    this.next,
    this.previous,
    this.list,
  });

  // ================== //
  //
  // HELPERS
  //
  void clear() {
    list = <T>[];
  }

  int get length {
    return list?.length ?? 0;
  }

  /// =============================================================================/
  /// GET API LIST ================================================================/
  /// =============================================================================/
  ///
  /// Generic function to call list API
  /// This will be used to get a list/results API and handle pagination.
  ///
  /// @[PARAM]
  /// String? search          - Optional keyword to search by
  /// Function? onSuccess     - Optional callback function on successful API call
  /// Function? onError       - Optional callback function on unsuccessful API call
  ///
  /// @[RETURN]
  /// Map<String, dynamic>    - map containing information about response
  /// class fields should be updated to reflect API response/results
  ///
  Future<Map<String, dynamic>> getApiList({String? search, Function? onSuccess, Function? onError}) async {
    updating = true;

    // build request
    Map<String, String> headers = headerNoAuth();
    if (token != null && token != '') {
      // get header if applicable
      headers = headerTokenAuth(token: token!);
    }

    // generate uri
    Uri uri = uriApiBase;
    if (search != null) {
      uri = Uri.parse(uri.toString() + "?search=$search");
    }

    // send HTTP request to endpoint
    http.Response response;
    try {
      response = await client.get(uri, headers: headers);
    } catch (e) {
      updating = false;
      logApiPrint("ResultsService.callApiList<${T.toString()}>: HTTP error\n${e.toString()}", tag: "EXP");
      return defaultErrorMap();
    }

    // deserialize json
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      logApiPrint("ResultsService.callApiList<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
      return defaultErrorMap();
    }

    // process response
    updating = false;
    if (response.statusCode == 200) {
      // 200 -> valid
      DjangoPaginatedApiJson<T> res = DjangoPaginatedApiJson<T>.fromJson(json: decoded, fromJson: fromJson);
      next = res.next;
      previous = res.previous;
      count = res.count;
      list = res.results;
      if (onSuccess != null) {
        onSuccess();
      }
      return defaultSuccessMap(message: decoded['message'], extras: <String, dynamic>{"count": count});
    } else if (response.statusCode == 401) {
      // 401 -> unauthorized
      if (onError != null) {
        onError();
      }
      return defaultErrorMap(message: decoded['detail']);
    } else {
      // 400, 500 and others -> error
      if (onError != null) {
        onError();
      }
      return defaultErrorMap(message: decoded['message']);
    }
  }

  /// =======================================/
  /// GET NEXT
  ///
  /// @[PARAM]
  /// bool addResults       - add results to existing list, default is to replace
  ///
  /// @[RETURN]
  /// Map<String, dynamic>  - map containing information about response
  ///
  Future<Map<String, dynamic>> getNext({bool addResults = false}) async {
    if (next != null) {
      updating = true;

      // get appropriate header
      Map<String, String> headers = headerNoAuth();
      if (token != null) {
        headers = headerTokenAuth(token: token!);
      }

      // send HTTP request to endpoint
      http.Response response;
      try {
        response = await client.get(Uri.parse(next!), headers: headers);
      } catch (e) {
        updating = false;
        logApiPrint("ResultsService.callNext<${T.toString()}>: HTTP error\n${e.toString()}", tag: "EXP");
        return defaultErrorMap();
      }
      // Successful HTTP request
      if (response.statusCode == 200) {
        // deserialize json
        Map<String, dynamic> decoded;
        try {
          decoded = jsonDecode(response.body);
        } catch (e) {
          logApiPrint("ResultsService.callNext<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
          return defaultErrorMap();
        }

        // process json
        DjangoPaginatedApiJson<T> res = DjangoPaginatedApiJson<T>.fromJson(json: decoded, fromJson: fromJson);
        next = res.next;
        previous = res.previous;
        count = res.count;
        if (addResults) {
          list = List<T>.from(list ?? <T>[])..addAll(res.results ?? <T>[]);
        } else {
          // replace results
          list = res.results;
        }
        return defaultSuccessMap(message: "Updated ${T.toString()}(s) list.", extras: <String, dynamic>{"count": count});
      }
    }
    // no next - error
    return defaultErrorMap();
  }

  /// =======================================/
  /// GET PREV
  ///
  /// @[RETURN]
  /// Map<String, dynamic>  - map containing information about response
  ///
  Future<Map<String, dynamic>> getPrevious() async {
    if (previous != null) {
      updating = true;

      // get appropriate header
      Map<String, String> headers = headerNoAuth();
      if (token != null) {
        headers = headerTokenAuth(token: token!);
      }

      // send HTTP request to endpoint
      http.Response response;
      try {
        response = await client.get(Uri.parse(previous!), headers: headers);
      } catch (e) {
        updating = false;
        logApiPrint("ResultsService.callPrevious<${T.toString()}>: HTTP error\n${e.toString()}", tag: "EXP");
        return defaultErrorMap();
      }

      // Successful HTTP request
      if (response.statusCode == 200) {
        // deserialize json
        Map<String, dynamic> decoded;
        try {
          decoded = jsonDecode(response.body);
        } catch (e) {
          logApiPrint("ResultsService.callPrevious<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
          return defaultErrorMap();
        }

        // process json
        DjangoPaginatedApiJson<T> res = DjangoPaginatedApiJson<T>.fromJson(json: decoded, fromJson: fromJson);
        next = res.next;
        previous = res.previous;
        count = res.count;
        list = res.results;
        return defaultSuccessMap(message: "Updated ${T.toString()}(s) list.", extras: <String, dynamic>{"count": count});
      }
    }
    // no prev - error
    return defaultErrorMap();
  }

  /// =============================================================================/
  /// GET API DETAILS =============================================================/
  /// =============================================================================/
  ///
  /// Generic function to call details API
  /// This will generally be to get more information about a particular (single)
  /// object instance. Usually this is called by id/pk
  ///
  /// @[PARAM]
  /// String id             - id of object to lookup
  /// Function onSuccess    - Optional callback function on successful API call
  /// Function onError      - Optional callback function on unsuccessful API call
  ///
  /// @[RETURN]
  /// Map<String, dynamic>  - map containing information about response
  ///
  Future<Map<String, dynamic>> getApiDetails({required String id, Function? onSuccess, Function? onError}) async {
    updating = true;

    // build request
    Map<String, String> headers = headerNoAuth();
    if (token != null && token != '') {
      // get header if applicable
      headers = headerTokenAuth(token: token!);
    }

    // send HTTP request to endpoint
    Uri uri = uriApiBase.replace(path: uriApiBase.path + "$id/");
    http.Response response;
    try {
      response = await client.get(uri, headers: headers);
    } catch (e) {
      updating = false;
      logApiPrint("ResultsService.callApiDetails<${T.toString()}>: HTTP error\n${e.toString()}", tag: "EXP");
      return defaultErrorMap();
    }

    // deserialize json
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      logApiPrint("ResultsService.callApiDetails<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
      return defaultErrorMap();
    }

    // process response
    updating = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      // 200 -> valid
      try {  // decode result itself
        resultDetails = fromJson(decoded['results']);
      } catch(e) {
        logApiPrint("ResultsService.callApiDetails<${T.toString()}>: fromJson error\n${e.toString()}", tag: "EXP");
      }
      if (onSuccess != null) {
        onSuccess();
      }
      return defaultSuccessMap(message: decoded['message'], extras: <String, dynamic>{'result': resultDetails});
    } else if (response.statusCode == 401) {
      // 401 -> unauthorized
      if (onError != null) {
        onError();
      }
      return defaultErrorMap(message: decoded['detail']);
    } else {
      // 400, 500 and others -> error
      if (onError != null) {
        onError();
      }
      return defaultErrorMap(message: decoded['message']);
    }
  }
}
