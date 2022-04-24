import 'dart:convert';

import 'package:danielnazarian_com/models/post.dart';
import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:http/src/response.dart';

// ====================================================
// POSTS API TEST VALUES ==============================
// ====================================================

class PostsApiTestValues {
  // id
  String idValid = 'valid';
  String id400Error = '400error';
  String id500Error = '500error';

  // searches
  String search400Error = '400error';
  String search500Error = '500error';

  // next
  String nextPostsValid = 'posts-nextValid?page=2';
  String nextPosts400Error = 'posts-next400Error?page=2';
  String nextPosts500Error = 'posts-next500Error?page=2';

  // prev
  String prevPostsValid = 'posts-prevValid?page=2';
  String prevPosts400Error = 'posts-prev400Error?page=2';
  String prevPosts500Error = 'posts-prev500Error?page=2';

  //
  // LIST - responses
  //
  Map<String, dynamic> responseDataListValid() {
    return {
      "count": 8,
      "next": nextPostsValid,
      "previous": prevPostsValid,
      "message": "Successfully retrieved results.",
      "results": [
        {
          "id": "b60a208e-9d32-4dcc-9bc7-13e80654f7be",
          "title": "Obsidian - Git and iOS DEBUG",
          "pinned": true,
          "datetime_created": "2022-04-12T22:08:32.685932Z",
          "author": "44005471-1d86-415f-85a7-dabba7e0e5b3",
          "author_ref": {
            "id": "44005471-1d86-415f-85a7-dabba7e0e5b3",
            "email": "danielnazarian@outlook.com",
            "first_name": "Daniel",
            "last_name": "Nazarian",
            "stringify": "Daniel Nazarian",
            "is_staff": true
          },
          "image":
              "https://dansbackend.s3.amazonaws.com/media-debug/44005471-1d86-415f-85a7-dabba7e0e5b3/posts/b60a208e-9d32-4dcc-9bc7-13e80654f7be/image.png"
        },
        {
          "id": "1384a29b-22ac-4230-9671-593c43267d57",
          "title": "Flutter SEO - Intro + SEO Renderer DEBUG",
          "pinned": true,
          "datetime_created": "2022-02-28T23:53:38.747845Z",
          "author": "44005471-1d86-415f-85a7-dabba7e0e5b3",
          "author_ref": {
            "id": "44005471-1d86-415f-85a7-dabba7e0e5b3",
            "email": "danielnazarian@outlook.com",
            "first_name": "Daniel",
            "last_name": "Nazarian",
            "stringify": "Daniel Nazarian",
            "is_staff": true
          },
          "image":
              "https://dansbackend.s3.amazonaws.com/media-debug/44005471-1d86-415f-85a7-dabba7e0e5b3/posts/1384a29b-22ac-4230-9671-593c43267d57/image.png"
        },
      ]
    };
  }

  Response responseListValid() {
    return Response(json.encode(responseDataListValid()), 200);
  }

  ApiResponse<Post> responseDataList400Error = ApiResponseError<Post>(message: "Failed retrieving results.");

  Response responseList400Error() {
    return Response(json.encode(responseDataList400Error.toMap()), 400);
  }

  ApiResponse<Post> responseDataList500Error = ApiResponseError<Post>(message: "Internal list server error.");

  Response responseList500Error() {
    return Response(json.encode(responseDataList500Error.toMap()), 500);
  }

  //
  // RETRIEVE - responses
  //
  Map<String, dynamic> responseDataRetrieveValid = <String, dynamic>{
    "message": "Successfully retrieved details.",
    "id": "1384a29b-22ac-4230-9671-593c43267d57",
    "title": "Flutter SEO - Intro + SEO Renderer DEBUG",
    "pinned": true,
    "datetime_created": "2022-02-28T23:53:38.747845Z",
    "author": "44005471-1d86-415f-85a7-dabba7e0e5b3",
    "author_ref": {
      "id": "44005471-1d86-415f-85a7-dabba7e0e5b3",
      "email": "danielnazarian@outlook.com",
      "first_name": "Daniel",
      "last_name": "Nazarian",
      "stringify": "Daniel Nazarian",
      "is_staff": true
    },
    "image":
        "https://dansbackend.s3.amazonaws.com/media-debug/44005471-1d86-415f-85a7-dabba7e0e5b3/posts/1384a29b-22ac-4230-9671-593c43267d57/image.png"
  };

  Response responseRetrieveValid() {
    return Response(json.encode(responseDataRetrieveValid), 200);
  }

  ApiResponse<Post> responseDataRetrieve400Error = ApiResponseError<Post>(message: "Failed retrieving details.");

  Response responseRetrieve400Error() {
    return Response(json.encode(responseDataRetrieve400Error.toMap()), 400);
  }

  ApiResponse<Post> responseDataRetrieve500Error = ApiResponseError<Post>(message: "Internal retrieve server error.");

  Response responseRetrieve500Error() {
    return Response(json.encode(responseDataRetrieve500Error.toMap()), 500);
  }

  //
  // NEXT - responses
  //
  Map<String, dynamic> responseDataNextValid = <String, dynamic>{
    "count": 5,
    "next": null,
    "previous": null,
    "message": "Successfully retrieved next results.",
    "results": [
      {
        "id": "b60a208e-9d32-4dcc-9bc7-13e80654f7be",
        "title": "Obsidian - Git and iOS DEBUG",
        "pinned": true,
        "datetime_created": "2022-04-12T22:08:32.685932Z",
        "author": "44005471-1d86-415f-85a7-dabba7e0e5b3",
        "author_ref": {
          "id": "44005471-1d86-415f-85a7-dabba7e0e5b3",
          "email": "danielnazarian@outlook.com",
          "first_name": "Daniel",
          "last_name": "Nazarian",
          "stringify": "Daniel Nazarian",
          "is_staff": true
        },
        "image":
            "https://dansbackend.s3.amazonaws.com/media-debug/44005471-1d86-415f-85a7-dabba7e0e5b3/posts/b60a208e-9d32-4dcc-9bc7-13e80654f7be/image.png"
      },
      {
        "id": "1384a29b-22ac-4230-9671-593c43267d57",
        "title": "Flutter SEO - Intro + SEO Renderer DEBUG",
        "pinned": true,
        "datetime_created": "2022-02-28T23:53:38.747845Z",
        "author": "44005471-1d86-415f-85a7-dabba7e0e5b3",
        "author_ref": {
          "id": "44005471-1d86-415f-85a7-dabba7e0e5b3",
          "email": "danielnazarian@outlook.com",
          "first_name": "Daniel",
          "last_name": "Nazarian",
          "stringify": "Daniel Nazarian",
          "is_staff": true
        },
        "image":
            "https://dansbackend.s3.amazonaws.com/media-debug/44005471-1d86-415f-85a7-dabba7e0e5b3/posts/1384a29b-22ac-4230-9671-593c43267d57/image.png"
      },
      {
        "id": "1384a29b-22ac-4230-9671-593c43267d57",
        "title": "third article",
        "pinned": true,
        "datetime_created": "2022-02-28T23:53:38.747845Z",
        "author": "44005471-1d86-415f-85a7-dabba7e0e5b3",
        "author_ref": {
          "id": "44005471-1d86-415f-85a7-dabba7e0e5b3",
          "email": "danielnazarian@outlook.com",
          "first_name": "Daniel",
          "last_name": "Nazarian",
          "stringify": "Daniel Nazarian",
          "is_staff": true
        },
        "image":
            "https://dansbackend.s3.amazonaws.com/media-debug/44005471-1d86-415f-85a7-dabba7e0e5b3/posts/1384a29b-22ac-4230-9671-593c43267d57/image.png"
      },
    ]
  };

  Response responseNextValid() {
    return Response(json.encode(responseDataNextValid), 200);
  }

  ApiResponse<Post> responseDataNext400Error = ApiResponseError<Post>(message: "Failed retrieving next results.");
  Response responseNext400Error() {
    return Response(json.encode(responseDataNext400Error.toMap()), 400);
  }

  ApiResponse<Post> responseDataNext500Error = ApiResponseError<Post>(message: "Internal next server error.");
  Response responseNext500Error() {
    return Response(json.encode(responseDataNext500Error.toMap()), 500);
  }

  //
  // PREV - responses
  //
  Map<String, dynamic> responseDataPrevValid = <String, dynamic>{
    "count": 5,
    "next": null,
    "previous": null,
    "message": "Successfully retrieved prev results.",
    "results": [
      {
        "id": "b60a208e-9d32-4dcc-9bc7-13e80654f7be",
        "title": "Obsidian - Git and iOS DEBUG",
        "pinned": true,
        "datetime_created": "2022-04-12T22:08:32.685932Z",
        "author": "44005471-1d86-415f-85a7-dabba7e0e5b3",
        "author_ref": {
          "id": "44005471-1d86-415f-85a7-dabba7e0e5b3",
          "email": "danielnazarian@outlook.com",
          "first_name": "Daniel",
          "last_name": "Nazarian",
          "stringify": "Daniel Nazarian",
          "is_staff": true
        },
        "image":
            "https://dansbackend.s3.amazonaws.com/media-debug/44005471-1d86-415f-85a7-dabba7e0e5b3/posts/b60a208e-9d32-4dcc-9bc7-13e80654f7be/image.png"
      },
      {
        "id": "1384a29b-22ac-4230-9671-593c43267d57",
        "title": "Flutter SEO - Intro + SEO Renderer DEBUG",
        "pinned": true,
        "datetime_created": "2022-02-28T23:53:38.747845Z",
        "author": "44005471-1d86-415f-85a7-dabba7e0e5b3",
        "author_ref": {
          "id": "44005471-1d86-415f-85a7-dabba7e0e5b3",
          "email": "danielnazarian@outlook.com",
          "first_name": "Daniel",
          "last_name": "Nazarian",
          "stringify": "Daniel Nazarian",
          "is_staff": true
        },
        "image":
            "https://dansbackend.s3.amazonaws.com/media-debug/44005471-1d86-415f-85a7-dabba7e0e5b3/posts/1384a29b-22ac-4230-9671-593c43267d57/image.png"
      },
      {
        "id": "1384a29b-22ac-4230-9671-593c43267d57",
        "title": "third article",
        "pinned": true,
        "datetime_created": "2022-02-28T23:53:38.747845Z",
        "author": "44005471-1d86-415f-85a7-dabba7e0e5b3",
        "author_ref": {
          "id": "44005471-1d86-415f-85a7-dabba7e0e5b3",
          "email": "danielnazarian@outlook.com",
          "first_name": "Daniel",
          "last_name": "Nazarian",
          "stringify": "Daniel Nazarian",
          "is_staff": true
        },
        "image":
            "https://dansbackend.s3.amazonaws.com/media-debug/44005471-1d86-415f-85a7-dabba7e0e5b3/posts/1384a29b-22ac-4230-9671-593c43267d57/image.png"
      },
    ]
  };

  Response responsePrevValid() {
    return Response(json.encode(responseDataPrevValid), 200);
  }

  ApiResponse<Post> responseDataPrev400Error = ApiResponseError<Post>(message: "Failed retrieving prev results.");
  Response responsePrev400Error() {
    return Response(json.encode(responseDataPrev400Error.toMap()), 400);
  }

  ApiResponse<Post> responseDataPrev500Error = ApiResponseError<Post>(message: "Internal prev server error.");
  Response responsePrev500Error() {
    return Response(json.encode(responseDataPrev500Error.toMap()), 500);
  }
}
