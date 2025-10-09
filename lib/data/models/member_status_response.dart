class MemberStatusResponse {
  final String status;
  final String code;
  final String? memberStatus;
  final bool? isEditEnabled;
  final String? message;

  MemberStatusResponse({
    required this.status,
    required this.code,
    this.memberStatus,
    this.isEditEnabled,
    this.message,
  });

  factory MemberStatusResponse.fromJson(Map<String, dynamic> json) {
    return MemberStatusResponse(
      status: json['status'] ?? '',
      code: json['code']?.toString() ?? '',
      memberStatus: json['member_status'],
      isEditEnabled: json['is_edit_enabled'],
      message: json['message'],
    );
  }

  bool get isSuccess => status == 'success' && code == '200';
}

enum MemberStatusType {
  booked,
  occupied,
  canceled,
  autoCanceled,
  notBooked,
  checkoutNotBooked;

  static MemberStatusType fromString(String status) {
    switch (status) {
      case 'Booked':
        return MemberStatusType.booked;
      case 'Occupied':
        return MemberStatusType.occupied;
      case 'Canceled':
        return MemberStatusType.canceled;
      case 'AutoCanceled':
        return MemberStatusType.autoCanceled;
      case 'Checkout & Not-Booked':
        return MemberStatusType.checkoutNotBooked;
      default:
        return MemberStatusType.notBooked;
    }
  }
}
