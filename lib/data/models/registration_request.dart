class RegistrationRequest {
  final String name;
  final String phone;
  final String identificationType;
  final String identificationNumber;
  final String email;
  final String password;
  final String memberFinalPhoto;
  final String ipAddress;

  RegistrationRequest({
    required this.name,
    required this.phone,
    required this.identificationType,
    required this.identificationNumber,
    required this.email,
    required this.password,
    required this.memberFinalPhoto,
    required this.ipAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'identification_type': identificationType,
      'identification_number': identificationNumber,
      'email': email,
      'password': password,
      'member_final_photo': memberFinalPhoto,
      'ip_address': ipAddress,
    };
  }
}
