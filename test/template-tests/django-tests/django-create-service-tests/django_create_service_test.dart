import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mock_client.dart';
import 'django_create_service_test_values.dart';

// ===============================================================================
// EMAIL API TEST ================================================================
// ===============================================================================

DjangoCreateService djangoCreateService = DjangoCreateService(client: mockClient, uriApiBase: Uri.parse("127.0.0.1:8000"));
DjangoCreateServiceTestValues djangoCreateServiceTestValues = DjangoCreateServiceTestValues();
String apiName = "DjangoCreateService";

void main() {
  //
  // POST API TEST
  //
  String tagGroup = "POST -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      ApiResponse<dynamic> res = await djangoCreateService.postApi(body: djangoCreateServiceTestValues.requestBodyValid);
      expect(res.message, djangoCreateServiceTestValues.responseDataPostValid.message);
      expect(res.details, djangoCreateServiceTestValues.responseDataPostValid.details);
      expect(res.error, false);
    });

    test('$tagGroup 400 error', () async {
      ApiResponse<dynamic> res = await djangoCreateService.postApi(body: djangoCreateServiceTestValues.requestBody400Error);
      expect(res.message, djangoCreateServiceTestValues.responseDataPost400Error.message);
      expect(res.details, djangoCreateServiceTestValues.responseDataPost400Error.details);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<dynamic> res = await djangoCreateService.postApi(body: djangoCreateServiceTestValues.requestBody500Error);
      expect(res.message, djangoCreateServiceTestValues.responseDataPost500Error.message);
      expect(res.details, djangoCreateServiceTestValues.responseDataPost500Error.details);
      expect(res.error, true);
    });
  });
}
