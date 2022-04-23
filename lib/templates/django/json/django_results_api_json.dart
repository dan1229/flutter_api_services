
/// ===============================================================================/
/// RESULTS API JSON ==============================================================/
/// ===============================================================================/
///
/// Generic class to parse generic results from a Django backend
///
class DjangoResultsApiJson {
  String message;
  dynamic results;

  DjangoResultsApiJson({
    required this.message,
    this.results,
  });

  /// ===================================/
  ///
  /// JSON
  ///
  factory DjangoResultsApiJson.fromJson({required Map<String, dynamic> json, Function? fromJson}) => DjangoResultsApiJson(
    message: json["message"],
    results: json["results"] == null ? null : fromJson == null ? json['results'] : fromJson(json['results']),
  );
}
