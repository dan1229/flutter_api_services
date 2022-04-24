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
  final http.Client client;
  final Function fromJson; // This is the fromJson constructor on the model (T). Dart doesn't support generic constructors sadly (yet?)
  final Uri uriApiBase; // NOTE: this almost definitely should end in a '/'
  final String? token; // Optional, if API requires auth

  // properties - from API
  int? count;
  String? next;
  String? previous;
  List<T>? list = <T>[];
  T? resultDetails;

  // pagination properties
  int pageCurrent = 1;  // NOTE: page 1 is the start!!!
  int pageTotal = 1;

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

  void calculatePageCurrent() {
    if (next != null) {
      Uri uri = Uri.dataFromString(next!);
      String pageNum = uri.queryParameters['page'] ?? '1';
      pageCurrent = int.parse(pageNum) - 1;
    }
    else if (previous != null) {
      Uri uri = Uri.dataFromString(previous!);
      String pageNum = uri.queryParameters['page'] ?? '1';
      pageCurrent = int.parse(pageNum) + 1;
    }
  }

  void calculatePageTotal() {
    if (length > 0 && count != null) {
      pageTotal = count! ~/ length;  // count is the total, divided (round down) by the current list length
      int remainder = count! % length;
      if (remainder != 0) {
        pageTotal++;
      }
    }
  }

  Uri uriSearch({String? search}) {
    Uri uri = uriApiBase;
    if (search != null) {
      uri = Uri.parse(uri.toString() + "?search=$search");
    }
    return uri;
  }

  Uri uriDetails({required String id}) {
    return uriApiBase.replace(path: uriApiBase.path + "$id/");
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
  Future<ApiResponse<T>> getApiList({String? search, Function? onSuccess, Function? onError}) async {
    // build request
    Map<String, String> headers = headerNoAuth();
    if (token != null && token != '') {
      // get header if applicable
      headers = headerTokenAuth(token: token!);
    }

    // generate uri
    Uri uri = uriSearch(search: search);

    // send HTTP request to endpoint
    http.Response response;
    try {
      response = await client.get(uri, headers: headers);
    } catch (e) {
      logApiPrint("ResultsService.callApiList<${T.toString()}>: HTTP error\n${e.toString()}", tag: "EXP");
      return ApiResponseError<T>();
    }

    // deserialize json
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      logApiPrint("ResultsService.callApiList<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
      return ApiResponseError<T>();
    }

    // process response
    DjangoPaginatedApiJson<T> res = DjangoPaginatedApiJson<T>.fromJson(json: decoded, fromJson: fromJson);
    if (response.statusCode == 200) {
      // 200 -> valid
      next = res.next;
      previous = res.previous;
      count = res.count;
      list = res.results;

      // calculate page info
      calculatePageCurrent();
      calculatePageTotal();

      if (onSuccess != null) {
        onSuccess();
      }
      return ApiResponseSuccess<T>(message: res.message, list: list);
    } else if (response.statusCode == 401) {
      // 401 -> unauthorized
      if (onError != null) {
        onError();
      }
      return ApiResponseError<T>(message: decoded['detail']);
    } else {
      // 400, 500 and others -> error
      if (onError != null) {
        onError();
      }
      return ApiResponseError<T>(message: res.message);
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
  Future<ApiResponse<T>> getNext({bool addResults = false}) async {
    if (next != null) {
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
        logApiPrint("ResultsService.callNext<${T.toString()}>: HTTP error\n${e.toString()}", tag: "EXP");
        return ApiResponseError<T>();
      }

      // Successful HTTP request
      if (response.statusCode == 200) {
        // deserialize json
        Map<String, dynamic> decoded;
        try {
          decoded = jsonDecode(response.body);
        } catch (e) {
          logApiPrint("ResultsService.callNext<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
          return ApiResponseError<T>();
        }

        // process json
        DjangoPaginatedApiJson<T> res = DjangoPaginatedApiJson<T>.fromJson(json: decoded, fromJson: fromJson);
        next = res.next;
        previous = res.previous;
        count = res.count;
        calculatePageCurrent();
        if (addResults) {
          list = List<T>.from(list ?? <T>[])..addAll(res.results ?? <T>[]);
        } else {
          // replace results
          list = res.results;
        }
        return ApiResponseSuccess<T>(message: "Updated ${T.toString()}(s) list.", list: list);
      }
    }
    // no next - error
    return ApiResponseError<T>();
  }

  /// =======================================/
  /// GET PREVIOUS
  ///
  /// @[RETURN]
  /// ApiResponse           - error or success based on result(s)
  ///
  Future<ApiResponse<T>> getPrevious() async {
    if (previous != null) {
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
        logApiPrint("ResultsService.callPrevious<${T.toString()}>: HTTP error\n${e.toString()}", tag: "EXP");
        return ApiResponseError<T>();
      }

      // Successful HTTP request
      if (response.statusCode == 200) {
        // deserialize json
        Map<String, dynamic> decoded;
        try {
          decoded = jsonDecode(response.body);
        } catch (e) {
          logApiPrint("ResultsService.callPrevious<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
          return ApiResponseError<T>();
        }

        // process json
        DjangoPaginatedApiJson<T> res = DjangoPaginatedApiJson<T>.fromJson(json: decoded, fromJson: fromJson);
        next = res.next;
        previous = res.previous;
        count = res.count;
        list = res.results;
        calculatePageCurrent();
        return ApiResponseSuccess<T>(message: "Updated ${T.toString()}(s) list.", list: list);
      }
    }
    // no prev - error
    return ApiResponseError<T>();
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
  Future<ApiResponse<T>> getApiDetails({required String id, Function? onSuccess, Function? onError}) async {
    // build request
    Map<String, String> headers = headerNoAuth();
    if (token != null && token != '') {
      // get header if applicable
      headers = headerTokenAuth(token: token!);
    }

    // send HTTP request to endpoint
    Uri uri = uriDetails(id: id);
    http.Response response;
    try {
      response = await client.get(uri, headers: headers);
    } catch (e) {
      logApiPrint("ResultsService.callApiDetails<${T.toString()}>: HTTP error\n${e.toString()}", tag: "EXP");
      return ApiResponseError<T>();
    }

    // deserialize json
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      logApiPrint("ResultsService.callApiDetails<${T.toString()}>: jsonDecode error\n${e.toString()}", tag: "EXP");
      return ApiResponseError<T>();
    }

    // process response
    print(decoded);
    DjangoResultsApiJson res = DjangoResultsApiJson.fromJson(json: decoded, fromJson: fromJson);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // 200 -> valid
      resultDetails = res.results;
      if (onSuccess != null) {
        onSuccess();
      }
      return ApiResponseSuccess<T>(message: res.message, details: resultDetails);
    } else if (response.statusCode == 401) {
      // 401 -> unauthorized
      if (onError != null) {
        onError();
      }
      return ApiResponseError<T>(message: decoded['detail']);
    } else {
      // 400, 500 and others -> error
      if (onError != null) {
        onError();
      }
      return ApiResponseError<T>(message: res.message);
    }
  }


}
