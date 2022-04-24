import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'service-tests/rest-api-tests/email-api-tests/email_api_test_values.dart';
import 'service-tests/rest-api-tests/posts-api-tests/posts_api_test.dart';
import 'service-tests/rest-api-tests/posts-api-tests/posts_api_test_values.dart';
import 'template-tests/django-tests/django-auth-service-tests/django_auth_service_test.dart';

// function to get test resource file/json and return as string
String getTestResource(String path) {
  String dir = Directory.current.path;
  return File('$dir/test/test_resources/$path').readAsStringSync();
}

//
// api setup
//

// posts api
DjangoResultsService postsApi = DjangoResultsService(client: Client());
PostsApiTestValues postApiTestValues = PostsApiTestValues();

// email api
EmailApi emailApi = EmailApi(client: Client());
EmailApiTestValues emailApiTestValues = EmailApiTestValues();

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
  // POSTS
  //
  // list
  if (url == postsApi.uriApiBase.toString().toLowerCase()) {
    return postsApiTestValues.responseListValid();
  }
  if (url == postsApi.uriSearch(search: postApiTestValues.search400Error).toString().toLowerCase()) {
    return postsApiTestValues.responseList400Error();
  }
  if (url == postsApi.uriSearch(search: postApiTestValues.search500Error).toString().toLowerCase()) {
    return postsApiTestValues.responseList500Error();
  }
  // retrieve
  if (url == postsApi.uriDetails(id: postApiTestValues.idValid).toString()) {
    return postsApiTestValues.responseRetrieveValid();
  }
  if (url == postsApi.uriDetails(id: postApiTestValues.id400Error).toString()) {
    return postsApiTestValues.responseRetrieve400Error();
  }
  if (url == postsApi.uriDetails(id: postApiTestValues.id500Error).toString()) {
    return postsApiTestValues.responseRetrieve500Error();
  }
  // next
  if (url.contains(postApiTestValues.nextPostsValid.toLowerCase())) {
    return postsApiTestValues.responseNextValid();
  }
  if (url.contains(postApiTestValues.nextPosts400Error.toLowerCase())) {
    return postsApiTestValues.responseNext400Error();
  }
  if (url.contains(postApiTestValues.nextPosts500Error.toLowerCase())) {
    return postsApiTestValues.responseNext500Error();
  }
  // prev
  if (url.contains(postApiTestValues.prevPostsValid.toLowerCase())) {
    return postsApiTestValues.responsePrevValid();
  }
  if (url.contains(postApiTestValues.prevPosts400Error.toLowerCase())) {
    return postsApiTestValues.responsePrev400Error();
  }
  if (url.contains(postApiTestValues.prevPosts500Error.toLowerCase())) {
    return postsApiTestValues.responsePrev500Error();
  }
  //
  // AUTH
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
  // EMAIL
  //
  // email
  if (url == emailApi.uriApiBase.toString().toLowerCase()) {
    Response response = emailApiTestValues.responseSendEmailValid();
    Map<String, dynamic> jsonBody = json.decode(request.body);
    if (const MapEquality<String, dynamic>().equals(jsonBody, emailApiTestValues.requestSendEmailValid())) {
      // valid email
      response = emailApiTestValues.responseSendEmailValid();
    }
    if (const MapEquality<String, dynamic>().equals(jsonBody, emailApiTestValues.requestSendEmailValidWithSubject())) {
      // valid email and subject
      response = emailApiTestValues.responseSendEmailValid();
    }
    if (const MapEquality<String, dynamic>().equals(jsonBody, emailApiTestValues.requestSendEmail400Error())) {
      // invalid email
      response = emailApiTestValues.responseSendEmail400Error();
    }
    if (const MapEquality<String, dynamic>().equals(jsonBody, emailApiTestValues.requestSendEmail500Error())) {
      // 500 error
      response = emailApiTestValues.responseSendEmail500Error();
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
