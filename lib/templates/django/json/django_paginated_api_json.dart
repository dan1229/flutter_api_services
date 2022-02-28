
/// ===============================================================================/
/// PAGINATED API JSON ============================================================/
/// ===============================================================================/
///
/// Generic class to parse paginated results from a Django backend
/// Specifically - the `PageNumberPagination` class
///
class DjangoPaginatedApiJson<T> {
  int? count;
  String? next;
  String? previous;
  List<T>? results;

  DjangoPaginatedApiJson({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  /// ===================================/
  ///
  /// JSON
  ///
  factory DjangoPaginatedApiJson.fromJson({required Map<String, dynamic> json, required Function fromJson}) => DjangoPaginatedApiJson<T>(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: json["results"] == null ? null : List<T>.from(json["results"].map((dynamic x) => fromJson(x))),
  );
}
