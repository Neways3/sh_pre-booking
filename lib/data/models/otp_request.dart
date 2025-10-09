// app/data/models/otp_request.dart
class OtpRequest {
  final String phone;

  OtpRequest({required this.phone});

  Map<String, dynamic> toJson() {
    return {'phone': phone};
  }

  factory OtpRequest.fromJson(Map<String, dynamic> json) {
    return OtpRequest(phone: json['phone'] ?? '');
  }
}

class OtpVerificationRequest {
  final String userId;
  final String phone;

  OtpVerificationRequest({required this.userId, required this.phone});

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'phone': phone};
  }
}
