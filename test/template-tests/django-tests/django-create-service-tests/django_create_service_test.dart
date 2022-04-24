import 'package:danielnazarian_com/services/rest-apis/email_api.dart';
import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mock_client.dart';
import 'email_api_test_values.dart';

// ===============================================================================
// EMAIL API TEST ================================================================
// ===============================================================================

EmailApi api = EmailApi(client: mockClient);
EmailApiTestValues emailApiTestValues = EmailApiTestValues();
String apiName = "EmailApi";

void main() {
  //
  // POST EMAIL API TEST
  //
  String tagGroup = "SEND EMAIL (POST) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      ApiResponse<dynamic> res = await api.sendEmail(message: emailApiTestValues.messageValid);
      expect(res.message, emailApiTestValues.responseDataSendEmailValid.message);
      expect(res.details, emailApiTestValues.responseDataSendEmailValid.details);
      expect(res.error, false);
    });

    test('$tagGroup valid with subject', () async {
      ApiResponse<dynamic> res = await api.sendEmail(message: emailApiTestValues.messageValid, subject: emailApiTestValues.subjectValid);
      expect(res.message, emailApiTestValues.responseDataSendEmailValid.message);
      expect(res.details, emailApiTestValues.responseDataSendEmailValid.details);
      expect(res.error, false);
    });

    test('$tagGroup 400 error', () async {
      ApiResponse<dynamic> res = await api.sendEmail(message: emailApiTestValues.message400Error);
      expect(res.message, emailApiTestValues.responseDataSendEmail400Error.message);
      expect(res.details, emailApiTestValues.responseDataSendEmail400Error.details);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<dynamic> res = await api.sendEmail(message: emailApiTestValues.message500Error);
      expect(res.message, emailApiTestValues.responseDataSendEmail500Error.message);
      expect(res.details, emailApiTestValues.responseDataSendEmail500Error.details);
      expect(res.error, true);
    });
  });
}
