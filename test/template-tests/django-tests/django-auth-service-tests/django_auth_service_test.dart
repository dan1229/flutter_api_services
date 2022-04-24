import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mock_client.dart';
import 'django_auth_service_test_values.dart';

// ===============================================================================
// AUTH API TEST =================================================================
// ===============================================================================

DjangoAuthService djangoAuthService = DjangoAuthService(client: mockClient, uriApiBase: Uri.parse("http://127.0.0.1:8000"));
DjangoAuthServiceTestValues djangoAuthServiceTestValues = DjangoAuthServiceTestValues();
String apiName = "DjangoAuthService";

void main() {

  //
  // POST LOGIN API TEST
  //
  String tagGroup = "LOGIN (POST) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      ApiResponse<dynamic> res = await djangoAuthService.postLoginApi(email: djangoAuthServiceTestValues.emailValid, password: djangoAuthServiceTestValues.passwordValid);
      expect(res.message, djangoAuthServiceTestValues.responseDataLoginValid.message);
      expect(res.list, djangoAuthServiceTestValues.responseDataLoginValid.list);
      expect(res.error, false);
    });

    test('$tagGroup invalid', () async {
      ApiResponse<dynamic> res = await djangoAuthService.postLoginApi(email: djangoAuthServiceTestValues.emailInvalid, password: djangoAuthServiceTestValues.passwordInvalid);
      expect(res.message, djangoAuthServiceTestValues.responseDataLoginInvalid.message);
      expect(res.list, djangoAuthServiceTestValues.responseDataLoginInvalid.list);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<dynamic> res = await djangoAuthService.postLoginApi(email: djangoAuthServiceTestValues.email500Error, password: djangoAuthServiceTestValues.password500Error);
      expect(res.message, djangoAuthServiceTestValues.responseDataLogin500Error.message);
      expect(res.list, djangoAuthServiceTestValues.responseDataLogin500Error.list);
      expect(res.error, true);
    });
  });


  //
  // POST SIGNUP API TEST
  //
  tagGroup = "SIGNUP (POST) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      ApiResponse<dynamic> res = await djangoAuthService.postSignupApi(email: djangoAuthServiceTestValues.emailValid, password: djangoAuthServiceTestValues.passwordValid);
      expect(res.message, djangoAuthServiceTestValues.responseDataSignupValid['message']);
      expect(res.details, djangoAuthServiceTestValues.responseDataSignupValid['results']);
      expect(res.error, false);
    });

    test('$tagGroup invalid', () async {
      ApiResponse<dynamic> res = await djangoAuthService.postSignupApi(email: djangoAuthServiceTestValues.emailInvalid, password: djangoAuthServiceTestValues.passwordInvalid);
      expect(res.message, djangoAuthServiceTestValues.responseDataSignupInvalid.message);
      expect(res.details, djangoAuthServiceTestValues.responseDataSignupInvalid.details);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<dynamic> res = await djangoAuthService.postSignupApi(email: djangoAuthServiceTestValues.email500Error, password: djangoAuthServiceTestValues.password500Error);
      expect(res.message, djangoAuthServiceTestValues.responseDataSignup500Error.message);
      expect(res.details, djangoAuthServiceTestValues.responseDataSignup500Error.details);
      expect(res.error, true);
    });


  });


}
