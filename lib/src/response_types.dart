class ApiResponse<T> {
  String message;
  bool error;
  List<T>? results;

  ApiResponse({this.message = 'Default API response.', this.error = false, this.results});

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'message': message,
      'results': results,
    };
  }
}

class ApiResponseSuccess<T> extends ApiResponse<T> {
  ApiResponseSuccess({String message="Successful request.", bool error = false, List<T>? results}) : super(message: message, error: error, results: results);
}

class ApiResponseError<T> extends ApiResponse<T> {
  ApiResponseError({String message="Error. Please try again later.", bool error=true, List<T>? results}) : super(message: message, error: error, results: results);
}
