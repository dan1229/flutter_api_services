import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mock_client.dart';
import '../../../test-models/test_model.dart';
import 'django_results_service_test_values.dart';

// ===============================================================================
// DJANGO RESULTS SERVICE TEST ===================================================
// ===============================================================================

DjangoResultsService<TestModel> djangoResultsService = DjangoResultsService<TestModel>(
    client: mockClient, uriApiBase: Uri.parse("http://127.0.0.1:8000/results/"), fromJson: (Map<String, dynamic> json) => TestModel.fromJson(json));
DjangoResultsServiceTestValues djangoResultsServiceTestValues = DjangoResultsServiceTestValues();
String apiName = "DjangoResultsService";

void main() {
  //
  // LIST API TEST
  //
  String tagGroup = "LIST (GET) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      ApiResponse<TestModel> res = await djangoResultsService.getApiList();
      expect(res.message, djangoResultsServiceTestValues.responseDataListValid()['message']);
      expect(res.list!.length, djangoResultsServiceTestValues.responseDataListValid()['results'].length);
      expect(res.details, null);
      expect(res.error, false);
    });

    test('$tagGroup 400 error', () async {
      ApiResponse<TestModel> res = await djangoResultsService.getApiList(search: djangoResultsServiceTestValues.search400Error);
      expect(res.message, djangoResultsServiceTestValues.responseDataList400Error.message);
      expect(res.list, djangoResultsServiceTestValues.responseDataList400Error.list);
      expect(res.details, null);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<TestModel> res = await djangoResultsService.getApiList(search: djangoResultsServiceTestValues.search500Error);
      expect(res.message, djangoResultsServiceTestValues.responseDataList500Error.message);
      expect(res.list, djangoResultsServiceTestValues.responseDataList500Error.list);
      expect(res.details, null);
      expect(res.error, true);
    });
  });

  //
  // RETRIEVE API TEST
  //
  tagGroup = "RETRIEVE (GET) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      ApiResponse<TestModel> res = await djangoResultsService.getApiDetails(id: djangoResultsServiceTestValues.idValid);
      expect(res.message, djangoResultsServiceTestValues.responseDataRetrieveValid['message']);
      expect(res.details, djangoResultsServiceTestValues.responseDataRetrieveValid['results']);
      expect(res.list, null);
      expect(res.error, false);
    });

    test('$tagGroup 400 error', () async {
      ApiResponse<TestModel> res = await djangoResultsService.getApiDetails(id: djangoResultsServiceTestValues.id400Error);
      expect(res.message, djangoResultsServiceTestValues.responseDataRetrieve400Error.message);
      expect(res.details, djangoResultsServiceTestValues.responseDataRetrieve400Error.details);
      expect(res.list, null);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<TestModel> res = await djangoResultsService.getApiDetails(id: djangoResultsServiceTestValues.id500Error);
      expect(res.message, djangoResultsServiceTestValues.responseDataRetrieve500Error.message);
      expect(res.details, djangoResultsServiceTestValues.responseDataRetrieve500Error.details);
      expect(res.list, null);
      expect(res.error, true);
    });
  });

  //
  // NEXT API TEST
  //
  tagGroup = "NEXT (GET) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      djangoResultsService.next = djangoResultsServiceTestValues.nextResultsValid;
      ApiResponse<TestModel> res = await djangoResultsService.getNext();
      expect(res.message, djangoResultsServiceTestValues.responseDataNextValid['message']);
      expect(res.details, null);
      expect(res.list!.length, djangoResultsServiceTestValues.responseDataNextValid['results'].length);
      expect(res.error, false);
    });

    test('$tagGroup valid with LIST call', () async {
      ApiResponse<TestModel> res1 = await djangoResultsService.getApiList();
      expect(res1.message, djangoResultsServiceTestValues.responseDataListValid()['message']);
      expect(res1.list!.length, djangoResultsServiceTestValues.responseDataListValid()['results'].length);
      expect(res1.details, null);
      expect(res1.error, false);

      ApiResponse<TestModel> res2 = await djangoResultsService.getNext();
      expect(res2.message, djangoResultsServiceTestValues.responseDataNextValid['message']);
      expect(res2.details, null);
      expect(res2.list!.length, djangoResultsServiceTestValues.responseDataNextValid['results'].length);
      expect(res2.error, false);
    });

    test('$tagGroup 400 error', () async {
      djangoResultsService.next = djangoResultsServiceTestValues.nextResults400Error;
      ApiResponse<TestModel> res = await djangoResultsService.getNext();
      expect(res.message, djangoResultsServiceTestValues.responseDataNext400Error.message);
      expect(res.details, null);
      expect(res.list, djangoResultsServiceTestValues.responseDataNext400Error.list);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      djangoResultsService.next = djangoResultsServiceTestValues.nextResults500Error;
      ApiResponse<TestModel> res = await djangoResultsService.getNext();
      expect(res.message, djangoResultsServiceTestValues.responseDataNext500Error.message);
      expect(res.details, null);
      expect(res.list, djangoResultsServiceTestValues.responseDataNext500Error.list);
      expect(res.error, true);
    });
  });

  //
  // PREV API TEST
  //
  tagGroup = "PREV (GET) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      djangoResultsService.previous = djangoResultsServiceTestValues.prevResultsValid;
      ApiResponse<TestModel> res = await djangoResultsService.getPrevious();
      expect(res.message, djangoResultsServiceTestValues.responseDataPrevValid['message']);
      expect(res.details, null);
      expect(res.list!.length, djangoResultsServiceTestValues.responseDataPrevValid['results'].length);
      expect(res.error, false);
    });

    test('$tagGroup valid with LIST call', () async {
      ApiResponse<TestModel> res1 = await djangoResultsService.getApiList();
      expect(res1.message, djangoResultsServiceTestValues.responseDataListValid()['message']);
      expect(res1.list!.length, djangoResultsServiceTestValues.responseDataListValid()['results'].length);
      expect(res1.details, null);
      expect(res1.error, false);

      ApiResponse<TestModel> res2 = await djangoResultsService.getPrevious();
      expect(res2.message, djangoResultsServiceTestValues.responseDataPrevValid['message']);
      expect(res2.details, null);
      expect(res2.list!.length, djangoResultsServiceTestValues.responseDataPrevValid['results'].length);
      expect(res2.error, false);
    });

    test('$tagGroup 400 error', () async {
      djangoResultsService.previous = djangoResultsServiceTestValues.prevResults400Error;
      ApiResponse<TestModel> res = await djangoResultsService.getPrevious();
      expect(res.message, djangoResultsServiceTestValues.responseDataPrev400Error.message);
      expect(res.details, null);
      expect(res.list, djangoResultsServiceTestValues.responseDataPrev400Error.list);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      djangoResultsService.previous = djangoResultsServiceTestValues.prevResults500Error;
      ApiResponse<TestModel> res = await djangoResultsService.getPrevious();
      expect(res.message, djangoResultsServiceTestValues.responseDataPrev500Error.message);
      expect(res.details, null);
      expect(res.list, djangoResultsServiceTestValues.responseDataPrev500Error.list);
      expect(res.error, true);
    });
  });
}
