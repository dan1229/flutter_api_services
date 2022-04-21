class ApiResponse {
  String message;
  bool error;

  ApiResponse({this.message = 'Default API response.', this.error = false});
}

class ApiResponseSuccess extends ApiResponse {
  dynamic results;

  ApiResponseSuccess({String message = "Successful request.", bool error = false, this.results}) : super(message: message, error: error);
}

class ApiResponseError extends ApiResponse {
  dynamic results;

  ApiResponseError({String message="Error. Please try again later.", bool error=true, this.results}) : super(message: message, error: error);
}
