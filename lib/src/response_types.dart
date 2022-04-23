class ApiResponse {
  String message;
  bool error;
  Map<String, dynamic>? results;

  ApiResponse({this.message = 'Default API response.', this.error = false, this.results});

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'message': message,
      'results': results,
    };
  }

  List<T> list<T>() {
    return results!['list'] as List<T>;
  }
  T details<T>() {
    return results!['details'] as T;
  }
}

class ApiResponseSuccess extends ApiResponse {
  ApiResponseSuccess({String message="Successful request.", bool error = false, Map<String, dynamic>? results}) : super(message: message, error: error, results: results);
}

class ApiResponseError extends ApiResponse {
  ApiResponseError({String message="Error. Please try again later.", bool error=true, Map<String, dynamic>? results}) : super(message: message, error: error, results: results);
}
