class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });
}
