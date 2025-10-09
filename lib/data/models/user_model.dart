class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final String identificationType;
  final String identificationNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.identificationType,
    required this.identificationNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photo: json['photo'],
      identificationType: json['identification_type'] ?? '',
      identificationNumber: json['identification_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'identification_type': identificationType,
      'identification_number': identificationNumber,
    };
  }
}
