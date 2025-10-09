class DocumentUploadRequest {
  final List<String> documentTypeIds;
  final List<String> attachmentPaths;

  DocumentUploadRequest({
    required this.documentTypeIds,
    required this.attachmentPaths,
  });
}

class DocumentUploadResponse {
  final String status;
  final String code;
  final String message;

  DocumentUploadResponse({
    required this.status,
    required this.code,
    required this.message,
  });

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponse(
      status: json['status'] ?? '',
      code: json['code'] ?? '',
      message: json['message'] ?? '',
    );
  }

  bool get isSuccess => status == 'success' && code == '200';
}
