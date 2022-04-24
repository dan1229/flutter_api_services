import 'dart:convert';

import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:http/src/response.dart';

// ====================================================
// EMAIL API TEST VALUES ==============================
// ====================================================

class EmailApiTestValues {
  // messages
  final String messageValid = 'This is a valid email message.';
  final String message400Error = 'This is a message to trigger a 400 error.';
  final String message500Error = 'This is a message to trigger a 500 error.';
  // subjects
  final String subjectValid = 'This is a valid subject line.';


  //
  // SEND EMAIL - requests
  //
  Map<String, dynamic> requestSendEmailBase(String message, String? subject) {
    return <String, dynamic>{
      "message": message,
      "subject": subject,
    };
  }
  Map<String, dynamic> requestSendEmailValid() {
    return requestSendEmailBase(messageValid, null);
  }

  Map<String, dynamic> requestSendEmailValidWithSubject() {
    return requestSendEmailBase(messageValid, subjectValid);
  }

  Map<String, dynamic> requestSendEmail400Error() {
    return requestSendEmailBase(message400Error, null);
  }

  Map<String, dynamic> requestSendEmail500Error() {
    return requestSendEmailBase(message500Error, null);
  }

  //
  // SEND EMAIL - responses
  //
  ApiResponse<dynamic> responseDataSendEmailValid = ApiResponseSuccess<dynamic>(message: "Successfully sent email.");
  Response responseSendEmailValid() {
    return Response(json.encode(responseDataSendEmailValid.toMap()), 200);
  }

  ApiResponse<dynamic> responseDataSendEmail400Error = ApiResponseError<dynamic>(message: "Failed sending email.");
  Response responseSendEmail400Error() {
    return Response(json.encode(responseDataSendEmail400Error.toMap()), 400);
  }

  ApiResponse<dynamic> responseDataSendEmail500Error = ApiResponseError<dynamic>(message: "Internal server error.");
  Response responseSendEmail500Error() {
    return Response(json.encode(responseDataSendEmail500Error.toMap()), 500);
  }

}
