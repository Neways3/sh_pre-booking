class ApiResponse<T> {
  final String status;
  final String code;
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T? data) {
    return ApiResponse<T>(
      status: json['status'] ?? '',
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: data,
    );
  }

  bool get isSuccess => status == 'success';
}
