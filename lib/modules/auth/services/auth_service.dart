import 'dart:convert';

import 'package:get/get.dart';
import 'package:sh_m/core/constants/app_constants.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/login_request.dart';
import '../../../data/models/registration_request.dart';
import '../../../data/models/otp_request.dart';
import '../../../data/models/user_model.dart';
import '../../../services/api_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse> getRegistrationOtp(OtpRequest request) async {
    try {
      final response = await _apiService.post(
        AppConstants.getRegistrationOtpEndpoint,
        data: request.toJson(),
        includeApiSecret: true, // Include api_secret
        includeUserId: false, // Don't include user_id for registration
      );

      // json decoding if response data is a string
      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return ApiResponse.fromJson(responseData, responseData);
    } catch (e) {
      return ApiResponse(
        status: 'error',
        code: '500',
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> verifyOtp(Map<String, dynamic> request) async {
    try {
      final response = await _apiService.post(
        AppConstants.verifyOtpEndpoint,
        data: request,
        includeApiSecret: true, // Include api_secret
        includeUserId:
            false, // Don't include user_id (it's in the request data)
      );

      // json decoding if response data is a string
      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return ApiResponse.fromJson(responseData, null);
    } catch (e) {
      return ApiResponse(
        status: 'error',
        code: '500',
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> submitRegistration(
    RegistrationRequest request,
  ) async {
    try {
      final response = await _apiService.post(
        AppConstants.submitRegistrationEndpoint,
        data: request.toJson(),
        includeApiSecret: true, // Include api_secret
        includeUserId: false, // Don't include user_id for registration
      );

      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return ApiResponse.fromJson(responseData, responseData);
    } catch (e) {
      return ApiResponse(
        status: 'error',
        code: '500',
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<User>> login(LoginRequest request) async {
    try {
      final response = await _apiService.post(
        AppConstants.loginEndpoint,
        data: request.toJson(),
        includeApiSecret: true, // Include api_secret
        includeUserId: false, // Don't include user_id for login
      );

      // Decode the response data if it's a JSON string
      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      User? user;
      if (responseData['status'] == 'success') {
        user = User(
          id: responseData['user_id'].toString(),
          name: '',
          email: '',
          phone: request.phone,
          identificationType: '',
          identificationNumber: '',
        );
      }

      return ApiResponse.fromJson(responseData, user);
    } catch (e) {
      return ApiResponse(
        status: 'error',
        code: '500',
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Example of API that needs user_id (like getting user profile)
  Future<ApiResponse<User>> getUserProfile() async {
    try {
      final response = await _apiService.post(
        'get-user-profile',
        includeApiSecret: true, // Include api_secret
        includeUserId: true, // Include user_id from storage
      );

      User? user;
      if (response.data['status'] == 'success') {
        user = User.fromJson(response.data['user']);
      }

      return ApiResponse.fromJson(response.data, user);
    } catch (e) {
      return ApiResponse(
        status: 'error',
        code: '500',
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Example of API that doesn't need api_secret (like public endpoints)
  Future<ApiResponse> getPublicData() async {
    try {
      final response = await _apiService.post(
        'get-public-data',
        includeApiSecret: false, // Don't include api_secret
        includeUserId: false, // Don't include user_id
      );

      return ApiResponse.fromJson(response.data, null);
    } catch (e) {
      return ApiResponse(
        status: 'error',
        code: '500',
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> getForgotPasswordOtp(OtpRequest request) async {
    try {
      final response = await _apiService.post(
        AppConstants.forgotPasswordEndpoint,
        data: request.toJson(),
        includeApiSecret: true,
        includeUserId: false,
      );

      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return ApiResponse.fromJson(responseData, responseData);
    } catch (e) {
      return ApiResponse(
        status: 'error',
        code: '500',
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> submitNewPassword({
    required String userId,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiService.post(
        AppConstants.submitNewPasswordEndpoint,
        data: {
          'user_id': userId,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
        includeApiSecret: true,
        includeUserId: false,
      );

      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return ApiResponse.fromJson(responseData, null);
    } catch (e) {
      return ApiResponse(
        status: 'error',
        code: '500',
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
