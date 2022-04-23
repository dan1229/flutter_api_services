class ApiResponse {
  String message;
  bool error;
  dynamic results;

  ApiResponse({this.message = 'Default API response.', this.error = false, this.results});

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'message': message,
      'results': results,
    };
  }
}

class ApiResponseSuccess extends ApiResponse {
  ApiResponseSuccess({String message="Successful request.", bool error = false, dynamic results}) : super(message: message, error: error, results: results);
}

class ApiResponseError extends ApiResponse {
  ApiResponseError({String message="Error. Please try again later.", bool error=true, dynamic results}) : super(message: message, error: error, results: results);
}
