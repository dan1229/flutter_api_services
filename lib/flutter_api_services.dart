library flutter_api_services;

export 'src/http_client_base.dart' show HttpClientBase;
export 'src/response_types.dart' show ApiResponse, ApiResponseSuccess, ApiResponseError;
// Django REST Services
export 'templates/django/django_auth_service.dart' show DjangoAuthService;
export 'templates/django/django_results_service.dart' show DjangoResultsService;
export 'templates/django/django_create_service.dart' show DjangoCreateService;
export 'templates/django/json/django_paginated_api_json.dart' show DjangoPaginatedApiJson;