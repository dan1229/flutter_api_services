import 'package:danielnazarian_com/services/rest-apis/auth_api.dart';
import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mock_client.dart';
import 'auth_api_test_values.dart';

// ===============================================================================
// AUTH API TEST =================================================================
// ===============================================================================

AuthApi api = AuthApi(client: mockClient);
AuthApiTestValues authApiTestValues = AuthApiTestValues();
String apiName = "AuthApi";

void main() {

  //
  // POST LOGIN API TEST
  //
  String tagGroup = "LOGIN (POST) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      ApiResponse<dynamic> res = await api.postLoginApi(email: authApiTestValues.emailValid, password: authApiTestValues.passwordValid);
      expect(res.message, authApiTestValues.responseDataLoginValid.message);
      expect(res.list, authApiTestValues.responseDataLoginValid.list);
      expect(res.error, false);
    });

    test('$tagGroup invalid', () async {
      ApiResponse<dynamic> res = await api.postLoginApi(email: authApiTestValues.emailInvalid, password: authApiTestValues.passwordInvalid);
      expect(res.message, authApiTestValues.responseDataLoginInvalid.message);
      expect(res.list, authApiTestValues.responseDataLoginInvalid.list);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<dynamic> res = await api.postLoginApi(email: authApiTestValues.email500Error, password: authApiTestValues.password500Error);
      expect(res.message, authApiTestValues.responseDataLogin500Error.message);
      expect(res.list, authApiTestValues.responseDataLogin500Error.list);
      expect(res.error, true);
    });
  });


  //
  // POST SIGNUP API TEST
  //
  tagGroup = "SIGNUP (POST) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      ApiResponse<dynamic> res = await api.postSignupApi(email: authApiTestValues.emailValid, password: authApiTestValues.passwordValid);
      expect(res.message, authApiTestValues.responseDataSignupValid['message']);
      expect(res.details, authApiTestValues.responseDataSignupValid['results']);
      expect(res.error, false);
    });

    test('$tagGroup invalid', () async {
      ApiResponse<dynamic> res = await api.postSignupApi(email: authApiTestValues.emailInvalid, password: authApiTestValues.passwordInvalid);
      expect(res.message, authApiTestValues.responseDataSignupInvalid.message);
      expect(res.details, authApiTestValues.responseDataSignupInvalid.details);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<dynamic> res = await api.postSignupApi(email: authApiTestValues.email500Error, password: authApiTestValues.password500Error);
      expect(res.message, authApiTestValues.responseDataSignup500Error.message);
      expect(res.details, authApiTestValues.responseDataSignup500Error.details);
      expect(res.error, true);
    });


  });


}
