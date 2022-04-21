
/// ===============================================================================/
/// RESULTS API JSON ==============================================================/
/// ===============================================================================/
///
/// Generic class to parse generic results from a Django backend
///
class DjangoResultsApiJson<T> {
  String? message;
  T? results;

  DjangoResultsApiJson({
    this.message,
    this.results,
  });

  /// ===================================/
  ///
  /// JSON
  ///
  factory DjangoResultsApiJson.fromJson({required Map<String, dynamic> json, required Function fromJson}) => DjangoResultsApiJson<T>(
    message: json["message"],
    results: json["results"] == null ? null : fromJson(json['results']),
  );
}
