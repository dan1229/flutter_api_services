import 'package:danielnazarian_com/models/post.dart';
import 'package:danielnazarian_com/services/rest-apis/posts_api.dart';
import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mock_client.dart';
import 'posts_api_test_values.dart';

// ===============================================================================
// POSTS API TEST ================================================================
// ===============================================================================

PostsApi api = PostsApi(client: mockClient);
PostsApiTestValues postsApiTestValues = PostsApiTestValues();
String apiName = "PostsApi";

void main() {
  //
  // LIST API TEST
  //
  String tagGroup = "LIST (GET) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      ApiResponse<Post> res = await api.getApiList();
      expect(res.message, postsApiTestValues.responseDataListValid()['message']);
      expect(res.list!.length, postsApiTestValues.responseDataListValid()['results'].length);
      expect(res.details, null);
      expect(res.error, false);
    });

    test('$tagGroup 400 error', () async {
      ApiResponse<Post> res = await api.getApiList(search: postsApiTestValues.search400Error);
      expect(res.message, postsApiTestValues.responseDataList400Error.message);
      expect(res.list, postsApiTestValues.responseDataList400Error.list);
      expect(res.details, null);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<Post> res = await api.getApiList(search: postsApiTestValues.search500Error);
      expect(res.message, postsApiTestValues.responseDataList500Error.message);
      expect(res.list, postsApiTestValues.responseDataList500Error.list);
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
      ApiResponse<Post> res = await api.getApiDetails(id: postsApiTestValues.idValid);
      expect(res.message, postsApiTestValues.responseDataRetrieveValid['message']);
      expect(res.details, postsApiTestValues.responseDataRetrieveValid['results']);
      expect(res.list, null);
      expect(res.error, false);
    });

    test('$tagGroup 400 error', () async {
      ApiResponse<Post> res = await api.getApiDetails(id: postsApiTestValues.id400Error);
      expect(res.message, postsApiTestValues.responseDataRetrieve400Error.message);
      expect(res.details, postsApiTestValues.responseDataRetrieve400Error.details);
      expect(res.list, null);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      ApiResponse<Post> res = await api.getApiDetails(id: postsApiTestValues.id500Error);
      expect(res.message, postsApiTestValues.responseDataRetrieve500Error.message);
      expect(res.details, postsApiTestValues.responseDataRetrieve500Error.details);
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
      api.next = postsApiTestValues.nextPostsValid;
      ApiResponse<Post> res = await api.getNext();
      expect(res.message, postsApiTestValues.responseDataNextValid['message']);
      expect(res.details, null);
      expect(res.list!.length, postsApiTestValues.responseDataNextValid['results'].length);
      expect(res.error, false);
    });

    test('$tagGroup valid with LIST call', () async {
      ApiResponse<Post> res1 = await api.getApiList();
      expect(res1.message, postsApiTestValues.responseDataListValid()['message']);
      expect(res1.list!.length, postsApiTestValues.responseDataListValid()['results'].length);
      expect(res1.details, null);
      expect(res1.error, false);

      ApiResponse<Post> res2 = await api.getNext();
      expect(res2.message, postsApiTestValues.responseDataNextValid['message']);
      expect(res2.details, null);
      expect(res2.list!.length, postsApiTestValues.responseDataNextValid['results'].length);
      expect(res2.error, false);
    });

    test('$tagGroup 400 error', () async {
      api.next = postsApiTestValues.nextPosts400Error;
      ApiResponse<Post> res = await api.getNext();
      expect(res.message, postsApiTestValues.responseDataNext400Error.message);
      expect(res.details, null);
      expect(res.list, postsApiTestValues.responseDataNext400Error.list);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      api.next = postsApiTestValues.nextPosts500Error;
      ApiResponse<Post> res = await api.getNext();
      expect(res.message, postsApiTestValues.responseDataNext500Error.message);
      expect(res.details, null);
      expect(res.list, postsApiTestValues.responseDataNext500Error.list);
      expect(res.error, true);
    });
  });

  //
  // PREV API TEST
  //
  tagGroup = "PREV (GET) -";
  group('$apiName - $tagGroup API test', () {
    test('$tagGroup valid', () async {
      api.previous = postsApiTestValues.prevPostsValid;
      ApiResponse<Post> res = await api.getPrevious();
      expect(res.message, postsApiTestValues.responseDataPrevValid['message']);
      expect(res.details, null);
      expect(res.list!.length, postsApiTestValues.responseDataPrevValid['results'].length);
      expect(res.error, false);
    });

    test('$tagGroup valid with LIST call', () async {
      ApiResponse<Post> res1 = await api.getApiList();
      expect(res1.message, postsApiTestValues.responseDataListValid()['message']);
      expect(res1.list!.length, postsApiTestValues.responseDataListValid()['results'].length);
      expect(res1.details, null);
      expect(res1.error, false);

      ApiResponse<Post> res2 = await api.getPrevious();
      expect(res2.message, postsApiTestValues.responseDataPrevValid['message']);
      expect(res2.details, null);
      expect(res2.list!.length, postsApiTestValues.responseDataPrevValid['results'].length);
      expect(res2.error, false);
    });

    test('$tagGroup 400 error', () async {
      api.previous = postsApiTestValues.prevPosts400Error;
      ApiResponse<Post> res = await api.getPrevious();
      expect(res.message, postsApiTestValues.responseDataPrev400Error.message);
      expect(res.details, null);
      expect(res.list, postsApiTestValues.responseDataPrev400Error.list);
      expect(res.error, true);
    });

    test('$tagGroup 500 error', () async {
      api.previous = postsApiTestValues.prevPosts500Error;
      ApiResponse<Post> res = await api.getPrevious();
      expect(res.message, postsApiTestValues.responseDataPrev500Error.message);
      expect(res.details, null);
      expect(res.list, postsApiTestValues.responseDataPrev500Error.list);
      expect(res.error, true);
    });
  });

}
