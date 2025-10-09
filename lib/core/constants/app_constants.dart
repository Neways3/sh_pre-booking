class AppConstants {
  static const String appName = 'Auth App';
  static const String apiBaseUrl = 'https://erp.neways3.com/api/member';
  static const String apiSecret =
      'kAXan6SFy5U3UrzHMMQgCzFEHwU9jzuBF6kbsFMjRsCSY8fFVhwhRTZvBqrMbcK3';
  static const String documentUrl = 'https://documents.neways3.com/';

  // Storage Keys
  static const String userKey = 'user';
  static const String tokenKey = 'token';

  // API Endpoints
  static const String getRegistrationOtpEndpoint =
      '/registration/get-registration-otp';
  static const String verifyOtpEndpoint = '/registration/verify-otp';
  static const String submitRegistrationEndpoint =
      '/registration/submit-registration';
  static const String loginEndpoint = '/registration/login';
  static const String personalInfoEndpoint = '/registration/get-information';
  static const String updatePersonalInfoEndpoint =
      '/registration/update-personal-information';
  static const String documentUploadEndpoint = '/registration/upload-documents';
  static const String forgotPasswordEndpoint = '/registration/forgot-password';
  static const String submitNewPasswordEndpoint =
      '/registration/submit-new-password';
  static const String memberStatusEndpoint = '/registration/get-member-status';

  // Identification Types
  static const List<String> identificationTypes = [
    'NID',
    'Passport',
    'Driving License',
  ];
}
