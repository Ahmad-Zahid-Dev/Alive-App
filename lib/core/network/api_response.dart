/// Typed API response wrapper.
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;

  const ApiResponse({
    this.data,
    this.message,
    required this.success,
  });

  factory ApiResponse.success(T data) =>
      ApiResponse(data: data, success: true);

  factory ApiResponse.error(String message) =>
      ApiResponse(message: message, success: false);
}
