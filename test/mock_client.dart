import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'template-tests/django-tests/django-auth-service-tests/django_auth_service_test.dart';
import 'template-tests/django-tests/django-create-service-tests/django_create_service_test.dart';
import 'template-tests/django-tests/django-results-service-tests/django_results_service_test.dart';

// function to get test resource file/json and return as string
String getTestResource(String path) {
  String dir = Directory.current.path;
  return File('$dir/test/test_resources/$path').readAsStringSync();
}
/// ==========================================================
/// MOCK CLIENT ==============================================
/// ==========================================================
///
/// Mock client is used to simulate network requests and their responses.
/// Well designed tests CANNOT rely on actual network/API usage and so
/// we use this mockClient instance to avoid that.
///
MockClient mockClient = MockClient((Request request) async {
  String url = request.url.toString().toLowerCase();

  //
  // DJANGO RESULTS SERVICE
  //
  // list
  if (url == djangoResultsService.uriApiBase.toString().toLowerCase()) {
    return djangoResultsServiceTestValues.responseListValid();
  }
  if (url == djangoResultsService.uriSearch(search: djangoResultsServiceTestValues.search400Error).toString().toLowerCase()) {
    return djangoResultsServiceTestValues.responseList400Error();
  }
  if (url == djangoResultsService.uriSearch(search: djangoResultsServiceTestValues.search500Error).toString().toLowerCase()) {
    return djangoResultsServiceTestValues.responseList500Error();
  }
  // retrieve
  if (url == djangoResultsService.uriDetails(id: djangoResultsServiceTestValues.idValid).toString()) {
    return djangoResultsServiceTestValues.responseRetrieveValid();
  }
  if (url == djangoResultsService.uriDetails(id: djangoResultsServiceTestValues.id400Error).toString()) {
    return djangoResultsServiceTestValues.responseRetrieve400Error();
  }
  if (url == djangoResultsService.uriDetails(id: djangoResultsServiceTestValues.id500Error).toString()) {
    return djangoResultsServiceTestValues.responseRetrieve500Error();
  }
  // next
  if (url.contains(djangoResultsServiceTestValues.nextResultsValid.toLowerCase())) {
    return djangoResultsServiceTestValues.responseNextValid();
  }
  if (url.contains(djangoResultsServiceTestValues.nextResults400Error.toLowerCase())) {
    return djangoResultsServiceTestValues.responseNext400Error();
  }
  if (url.contains(djangoResultsServiceTestValues.nextResults500Error.toLowerCase())) {
    return djangoResultsServiceTestValues.responseNext500Error();
  }
  // prev
  if (url.contains(djangoResultsServiceTestValues.prevResultsValid.toLowerCase())) {
    return djangoResultsServiceTestValues.responsePrevValid();
  }
  if (url.contains(djangoResultsServiceTestValues.prevResults400Error.toLowerCase())) {
    return djangoResultsServiceTestValues.responsePrev400Error();
  }
  if (url.contains(djangoResultsServiceTestValues.prevResults500Error.toLowerCase())) {
    return djangoResultsServiceTestValues.responsePrev500Error();
  }
  //
  // DJANGO AUTH SERVICE
  //
  // login
  if (url == djangoAuthService.uriLogin().toString().toLowerCase()) {
    Response response = djangoAuthServiceTestValues.responseLogin500Error();
    Map<String, dynamic> jsonBody = json.decode(request.body);
    if (const MapEquality<String, dynamic>().equals(jsonBody, djangoAuthServiceTestValues.requestLoginValid())) {
      // valid login
      response = djangoAuthServiceTestValues.responseLoginValid();
    }
    if (const MapEquality<String, dynamic>().equals(jsonBody, djangoAuthServiceTestValues.requestLoginInvalid())) {
      // invalid login
      response = djangoAuthServiceTestValues.responseLoginInvalid();
    }
    if (const MapEquality<String, dynamic>().equals(jsonBody, djangoAuthServiceTestValues.requestLogin500Error())) {
      // 500 error
      response = djangoAuthServiceTestValues.responseLogin500Error();
    }
    return response;
  }
  // signup
  if (url == djangoAuthService.uriSignup().toString().toLowerCase()) {
    Response response = djangoAuthServiceTestValues.responseSignup500Error();
    Map<String, dynamic> jsonBody = json.decode(request.body);
    if (const MapEquality<String, dynamic>().equals(jsonBody, djangoAuthServiceTestValues.requestSignupValid())) {
      // valid signup
      response = djangoAuthServiceTestValues.responseSignupValid();
    }
    if (const MapEquality<String, dynamic>().equals(jsonBody, djangoAuthServiceTestValues.requestSignupInvalid())) {
      // invalid signup
      response = djangoAuthServiceTestValues.responseSignupInvalid();
    }
    if (const MapEquality<String, dynamic>().equals(jsonBody, djangoAuthServiceTestValues.requestLogin500Error())) {
      // 500 error
      response = djangoAuthServiceTestValues.responseSignup500Error();
    }
    return response;
  }
  //
  // DJANGO CREATE SERVICE
  //
  // email
  if (url == djangoCreateService.uriApiBase.toString().toLowerCase()) {
    Response response = djangoCreateServiceTestValues.responsePostValid();
    Map<String, dynamic> jsonBody = json.decode(request.body);
    if (const MapEquality<String, dynamic>().equals(jsonBody, djangoCreateServiceTestValues.requestPostValid())) {
      // valid email
      response = djangoCreateServiceTestValues.responsePostValid();
    }
    if (const MapEquality<String, dynamic>().equals(jsonBody, djangoCreateServiceTestValues.requestPost400Error())) {
      // invalid email
      response = djangoCreateServiceTestValues.responsePost400Error();
    }
    if (const MapEquality<String, dynamic>().equals(jsonBody, djangoCreateServiceTestValues.requestPost500Error())) {
      // 500 error
      response = djangoCreateServiceTestValues.responsePost500Error();
    }
    return response;
  }
  //
  // DEFAULT
  //
  else {
    return Response(json.encode(ApiResponseError().toMap()), 500);
  }
});
