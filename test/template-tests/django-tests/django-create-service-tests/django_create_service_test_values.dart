import 'dart:convert';

import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:http/src/response.dart';

// ====================================================
// DJANGO CREATE SERVICE TEST VALUES ==================
// ====================================================

class DjangoCreateServiceTestValues {
  //
  // POST - requests
  //
  Map<String, dynamic> requestPostBase(String message) {
    return <String, dynamic>{
      "message": message,
    };
  }

  Map<String, dynamic> requestPostValid() {
    return requestPostBase('Successful post request');
  }

  Map<String, dynamic> requestPost400Error() {
    return requestPostBase('400 post request');
  }

  Map<String, dynamic> requestPost500Error() {
    return requestPostBase('500 post request');
  }



  //
  // POST - responses
  //
  ApiResponse<dynamic> responseDataPostValid = ApiResponseSuccess<dynamic>(message: "Successfully sent post request.");
  Response responsePostValid() {
    return Response(json.encode(responseDataPostValid.toMap()), 200);
  }

  ApiResponse<dynamic> responseDataPost400Error = ApiResponseError<dynamic>(message: "Failed sending post request.");
  Response responsePost400Error() {
    return Response(json.encode(responseDataPost400Error.toMap()), 400);
  }

  ApiResponse<dynamic> responseDataPost500Error = ApiResponseError<dynamic>(message: "Internal server error sending post request.");
  Response responsePost500Error() {
    return Response(json.encode(responseDataPost500Error.toMap()), 500);
  }

}
