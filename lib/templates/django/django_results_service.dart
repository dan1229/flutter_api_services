import 'dart:convert';

import 'package:flutter_api_services/src/api_helpers.dart';
import 'package:flutter_api_services/src/response_types.dart';
import 'package:flutter_api_services/templates/django/json/django_paginated_api_json.dart';
import 'package:flutter_api_services/templates/django/json/django_results_api_json.dart';
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
  String? message;
  List<T>? list = <T>[];
  T? resultDetails;

  // pagination properties
  int pageCurrent = 1;  // NOTE: page 1 is the start!!!
  int pageTotal = 1;

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
  /// ApiResponse           - error or success based on result(s)
  ///
  Future<ApiResponse> getApiList({String? search, Function? onSuccess, Function? onError}) async {
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
      return ApiResponseError();
    }

    // deserialize json
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      logApiPrint("ResultsService.callApiList<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
      return ApiResponseError();
    }

    // process response
    updating = false;
    if (response.statusCode == 200) {
      // 200 -> valid
      bool newList = false;
      if (count == null) {
        newList = true;
      }
      DjangoPaginatedApiJson<T> res = DjangoPaginatedApiJson<T>.fromJson(json: decoded, fromJson: fromJson);
      next = res.next;
      previous = res.previous;
      count = res.count;
      list = res.results;
      message = res.message;

      // get current page number from next/prev
      String pageNum = '1';
      print(next != null);
      if (next != null) {
        Uri uri = Uri.dataFromString(next!);
        pageNum = uri.queryParameters['page'] ?? '1';
        print(pageNum);
        pageCurrent = int.parse(pageNum) ;
        print(pageCurrent);
      }

      // if we have a new list, figure out the total pages
      if (newList && length > 0 && count != null) {
        pageTotal = count! ~/ length;  // count is the total, divided (round down) by the current list length
        int remainder = count! % length;
        if (remainder != 0) {
          pageTotal++;
        }
      }

      if (onSuccess != null) {
        onSuccess();
      }
      return ApiResponseSuccess(message: message ?? "Success", results: list);
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
      return ApiResponseError(message: decoded['message']);
    }
  }

  /// =======================================/
  /// GET NEXT
  ///
  /// @[PARAM]
  /// bool addResults       - add results to existing list, default is to replace
  ///
  /// @[RETURN]
  /// ApiResponse           - error or success based on result(s)
  ///
  Future<ApiResponse> getNext({bool addResults = false}) async {
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
        return ApiResponseError();
      }

      // Successful HTTP request
      if (response.statusCode == 200) {
        // deserialize json
        Map<String, dynamic> decoded;
        try {
          decoded = jsonDecode(response.body);
        } catch (e) {
          logApiPrint("ResultsService.callNext<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
          return ApiResponseError();
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
        return ApiResponseSuccess(message: "Updated ${T.toString()}(s) list.", results: list);
      }
    }
    // no next - error
    return ApiResponseError();
  }

  /// =======================================/
  /// GET PREV
  ///
  /// @[RETURN]
  /// ApiResponse           - error or success based on result(s)
  ///
  Future<ApiResponse> getPrevious() async {
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
        return ApiResponseError();
      }

      // Successful HTTP request
      if (response.statusCode == 200) {
        // deserialize json
        Map<String, dynamic> decoded;
        try {
          decoded = jsonDecode(response.body);
        } catch (e) {
          logApiPrint("ResultsService.callPrevious<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
          return ApiResponseError();
        }

        // process json
        DjangoPaginatedApiJson<T> res = DjangoPaginatedApiJson<T>.fromJson(json: decoded, fromJson: fromJson);
        next = res.next;
        previous = res.previous;
        count = res.count;
        list = res.results;
        return ApiResponseSuccess(message: "Updated ${T.toString()}(s) list.", results: list);
      }
    }
    // no prev - error
    return ApiResponseError();
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
  /// ApiResponse           - error or success based on result(s)
  ///
  Future<ApiResponse> getApiDetails({required String id, Function? onSuccess, Function? onError}) async {
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
      return ApiResponseError();
    }

    // deserialize json
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      logApiPrint("ResultsService.callApiDetails<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
      return ApiResponseError();
    }

    // process response
    updating = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      // 200 -> valid
      DjangoResultsApiJson<T> res = DjangoResultsApiJson<T>.fromJson(json: decoded, fromJson: fromJson);
      resultDetails = res.results;
      message = res.message;
      if (onSuccess != null) {
        onSuccess();
      }
      return ApiResponseSuccess(message: message ?? "Success.", results: resultDetails);
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
      return ApiResponseError(message: decoded['message']);
    }
  }
}
