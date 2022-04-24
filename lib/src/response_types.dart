class ApiResponse<T> {
  String message;
  bool error;
  T? details;
  List<T>? list;

  ApiResponse({this.message = 'Default API response.', this.error = false, this.list, this.details});

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'message': message,
      // TODO should the key be 'results' and simply pick the not null one?
      'details': details,
      'list': list,
    };
  }

  // List<T> list<T>() {
  //   return results!['list'] as List<T>;
  // }
  // T details<T>() {
  //   return results!['details'] as T;
  // }
}

class ApiResponseSuccess<T> extends ApiResponse<T> {
  ApiResponseSuccess({String message="Successful request.", bool error = false, List<T>? list, T? details}) : super(message: message, error: error, list: list, details: details);
}

class ApiResponseError<T> extends ApiResponse<T> {
  ApiResponseError({String message="Error. Please try again later.", bool error=true,List<T>? list, T? details}) : super(message: message, error: error, list: list, details: details);
}
