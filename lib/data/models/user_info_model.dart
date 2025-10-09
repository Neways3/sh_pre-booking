// models/user_models.dart

class UserInfo {
  final String id;
  final String userType;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String identificationType;
  final String identificationNumber;
  final String password;
  final String emailVerify;
  final String phoneVerify;
  final String referralId;
  final String registrationIp;
  final String registrationLocation;
  final String isBlock;
  final String isRed;
  final String memberStatus;
  final String status;
  final String data;
  final String dateFilter;
  final String dateTime;
  final String createdAt;
  final String updatedAt;

  UserInfo({
    required this.id,
    required this.userType,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.identificationType,
    required this.identificationNumber,
    required this.password,
    required this.emailVerify,
    required this.phoneVerify,
    required this.referralId,
    required this.registrationIp,
    required this.registrationLocation,
    required this.isBlock,
    required this.isRed,
    required this.memberStatus,
    required this.status,
    required this.data,
    required this.dateFilter,
    required this.dateTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      userType: json['user_type'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photo: json['photo'] ?? '',
      identificationType: json['identification_type'] ?? '',
      identificationNumber: json['identification_number'] ?? '',
      password: json['password'] ?? '',
      emailVerify: json['email_verify'] ?? '',
      phoneVerify: json['phone_verify'] ?? '',
      referralId: json['referral_id'] ?? '',
      registrationIp: json['registraion_ip'] ?? '',
      registrationLocation: json['registration_location'] ?? '',
      isBlock: json['is_block'] ?? '',
      isRed: json['is_red'] ?? '',
      memberStatus: json['member_status'] ?? '',
      status: json['status'] ?? '',
      data: json['data'] ?? '',
      dateFilter: json['date_filter'] ?? '',
      dateTime: json['date_time'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_type': userType,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'identification_type': identificationType,
      'identification_number': identificationNumber,
      'password': password,
      'email_verify': emailVerify,
      'phone_verify': phoneVerify,
      'referral_id': referralId,
      'registraion_ip': registrationIp,
      'registration_location': registrationLocation,
      'is_block': isBlock,
      'is_red': isRed,
      'member_status': memberStatus,
      'status': status,
      'data': data,
      'date_filter': dateFilter,
      'date_time': dateTime,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PersonalInfo {
  final String id;
  final String userId;
  final String memberName;
  final String fatherName;
  final String genderId;
  final String genderName;
  final String findUsId;
  final String findUsName;
  final String occupationId;
  final String occupationName;
  final String religionId;
  final String religionName;
  final String bloodGroupId;
  final String bloodGroupName;
  final String countryId;
  final String countryName;
  final String divisionId;
  final String divisionName;
  final String districtId;
  final String districtName;
  final String thanaId;
  final String thanaName;
  final String dateOfBirth;
  final String relationId;
  final String relationName;
  final String contactName;
  final String contactNumber;
  final String address;
  final String maritalId;
  final String maritalName;
  final String educationId;
  final String educationName;
  final String note;
  final String status;
  final String uploaderInfo;
  final String data;
  final String dateFilter;
  final String createdAt;
  final String updatedAt;

  PersonalInfo({
    required this.id,
    required this.userId,
    required this.memberName,
    required this.fatherName,
    required this.genderId,
    required this.genderName,
    required this.findUsId,
    required this.findUsName,
    required this.occupationId,
    required this.occupationName,
    required this.religionId,
    required this.religionName,
    required this.bloodGroupId,
    required this.bloodGroupName,
    required this.countryId,
    required this.countryName,
    required this.divisionId,
    required this.divisionName,
    required this.districtId,
    required this.districtName,
    required this.thanaId,
    required this.thanaName,
    required this.dateOfBirth,
    required this.relationId,
    required this.relationName,
    required this.contactName,
    required this.contactNumber,
    required this.address,
    required this.maritalId,
    required this.maritalName,
    required this.educationId,
    required this.educationName,
    required this.note,
    required this.status,
    required this.uploaderInfo,
    required this.data,
    required this.dateFilter,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      memberName: json['member_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      genderId: json['gender_id'] ?? '',
      genderName: json['gender_name'] ?? '',
      findUsId: json['find_us_id'] ?? '',
      findUsName: json['find_us_name'] ?? '',
      occupationId: json['occupation_id'] ?? '',
      occupationName: json['occupation_name'] ?? '',
      religionId: json['religion_id'] ?? '',
      religionName: json['religion_name'] ?? '',
      bloodGroupId: json['blood_group_id'] ?? '',
      bloodGroupName: json['blood_group_name'] ?? '',
      countryId: json['country_id'] ?? '',
      countryName: json['country_name'] ?? '',
      divisionId: json['division_id'] ?? '',
      divisionName: json['division_name'] ?? '',
      districtId: json['district_id'] ?? '',
      districtName: json['district_name'] ?? '',
      thanaId: json['thana_id'] ?? '',
      thanaName: json['thana_name'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      relationId: json['relation_id'] ?? '',
      relationName: json['relation_name'] ?? '',
      contactName: json['contact_name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      address: json['address'] ?? '',
      maritalId: json['marital_id'] ?? '',
      maritalName: json['marital_name'] ?? '',
      educationId: json['education_id'] ?? '',
      educationName: json['education_name'] ?? '',
      note: json['note'] ?? '',
      status: json['status'] ?? '',
      uploaderInfo: json['uploader_info'] ?? '',
      data: json['data'] ?? '',
      dateFilter: json['date_filter'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'member_name': memberName,
      'father_name': fatherName,
      'gender_id': genderId,
      'gender_name': genderName,
      'find_us_id': findUsId,
      'find_us_name': findUsName,
      'occupation_id': occupationId,
      'occupation_name': occupationName,
      'religion_id': religionId,
      'religion_name': religionName,
      'blood_group_id': bloodGroupId,
      'blood_group_name': bloodGroupName,
      'country_id': countryId,
      'country_name': countryName,
      'division_id': divisionId,
      'division_name': divisionName,
      'district_id': districtId,
      'district_name': districtName,
      'thana_id': thanaId,
      'thana_name': thanaName,
      'date_of_birth': dateOfBirth,
      'relation_id': relationId,
      'relation_name': relationName,
      'contact_name': contactName,
      'contact_number': contactNumber,
      'address': address,
      'marital_id': maritalId,
      'marital_name': maritalName,
      'education_id': educationId,
      'education_name': educationName,
      'note': note,
      'status': status,
      'uploader_info': uploaderInfo,
      'data': data,
      'date_filter': dateFilter,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class DocumentInfo {
  final String id;
  final String userId;
  final String documentTypeId;
  final String documentTypeName;
  final String attachment;
  final String uploaderInfo;
  final String data;
  final String createdAt;
  final String updatedAt;

  DocumentInfo({
    required this.id,
    required this.userId,
    required this.documentTypeId,
    required this.documentTypeName,
    required this.attachment,
    required this.uploaderInfo,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentInfo.fromJson(Map<String, dynamic> json) {
    return DocumentInfo(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      documentTypeId: json['document_type_id'] ?? '',
      documentTypeName: json['document_type_name'] ?? '',
      attachment: json['attachment'] ?? '',
      uploaderInfo: json['uploader_info'] ?? '',
      data: json['data'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'document_type_id': documentTypeId,
      'document_type_name': documentTypeName,
      'attachment': attachment,
      'uploader_info': uploaderInfo,
      'data': data,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class UserInfoResponse {
  final String status;
  final String code;
  final int type;
  final UserInfo? userInfo;
  final PersonalInfo? personalInfo;
  final List<DocumentInfo>? documentInfo;
  final String? message;

  UserInfoResponse({
    required this.status,
    required this.code,
    required this.type,
    this.userInfo,
    this.personalInfo,
    this.documentInfo,
    this.message,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    List<DocumentInfo>? documents;

    if (json['document_info'] != null) {
      if (json['document_info'] is List) {
        documents = (json['document_info'] as List)
            .map((doc) => DocumentInfo.fromJson(doc))
            .toList();
      }
    }

    return UserInfoResponse(
      status: json['status'] ?? '',
      code: json['code'] ?? '',
      type: json['type'] ?? 0,
      userInfo: json['user_info'] != null
          ? UserInfo.fromJson(json['user_info'])
          : null,
      personalInfo: json['personal_info'] != null
          ? PersonalInfo.fromJson(json['personal_info'])
          : null,
      documentInfo: documents,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'type': type,
      'user_info': userInfo?.toJson(),
      'personal_info': personalInfo?.toJson(),
      'document_info': documentInfo?.map((doc) => doc.toJson()).toList(),
      'message': message,
    };
  }
}

class DropdownOption {
  final String id;
  final String text;

  DropdownOption({required this.id, required this.text});

  factory DropdownOption.fromJson(Map<String, dynamic> json) {
    return DropdownOption(id: json['id'] ?? '', text: json['text'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class UpdatePersonalInfoRequest {
  final String userId;
  final String fatherName;
  final String genderId;
  final String findUsId;
  final String occupationId;
  final String religionId;
  final String bloodGroupId;
  final String districtId;
  final String thanaId;
  final String emergencyContactRelation;
  final String maritalId;
  final String educationId;
  final String address;
  final String contactName;
  final String contactNumber;
  final String dateOfBirth;
  final String? note;
  final String? submitType;
  final String? editMemberFinalPhoto;

  UpdatePersonalInfoRequest({
    required this.userId,
    required this.fatherName,
    required this.genderId,
    required this.findUsId,
    required this.occupationId,
    required this.religionId,
    required this.bloodGroupId,
    required this.districtId,
    required this.thanaId,
    required this.emergencyContactRelation,
    required this.maritalId,
    required this.educationId,
    required this.address,
    required this.contactName,
    required this.contactNumber,
    required this.dateOfBirth,
    this.note,
    this.submitType,
    this.editMemberFinalPhoto,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'father_name': fatherName,
      'gender_id': genderId,
      'find_us_id': findUsId,
      'occupation_id': occupationId,
      'religion_id': religionId,
      'blood_group_id': bloodGroupId,
      'district_id': districtId,
      'thana_id': thanaId,
      'emergency_contact_relation': emergencyContactRelation,
      'marital_id': maritalId,
      'education_id': educationId,
      'address': address,
      'contact_name': contactName,
      'contact_number': contactNumber,
      'date_of_birth': dateOfBirth,
      'note': note,
      'submit_type': submitType,
      'edit_member_final_photo': editMemberFinalPhoto,
    };
  }
}
