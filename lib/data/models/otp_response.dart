class OtpResponse {
  String? status;
  String? code;
  String? phone;
  String? otp;

  OtpResponse({this.status, this.code, this.phone, this.otp});
  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      status: json['status'] ?? '',
      code: json['code'] ?? '',
      phone: json['phone'] ?? '',
      otp: json['otp'] ?? '',
    );
  }
}
