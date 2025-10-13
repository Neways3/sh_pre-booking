import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide FormData;
import 'package:sh_m/core/constants/app_constants.dart';
import 'package:sh_m/data/models/user_info_model.dart';
import '../../../services/api_service.dart';

class PersonalInfoService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<UserInfoResponse> getUserInfo(String userId) async {
    try {
      final response = await _apiService.post(
        AppConstants.personalInfoEndpoint,
        includeUserId: true,
      );

      var responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200) {
        return UserInfoResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to load user information');
      }
    } catch (e) {
      print('Error getting user info: $e');
      rethrow;
    }
  }

  Future<List<DropdownOption>> getOptions(String type) async {
    try {
      var requestData = {
        'api_secret': AppConstants.apiSecret,
        'select-active': 'active',
        'get-options': type,
      };

      final response = await dio.Dio(
        dio.BaseOptions(
          baseUrl: 'https://erp.neways3.com/',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ).get('', queryParameters: requestData);

      var responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200) {
        List<dynamic> data = responseData;
        return data.map((item) => DropdownOption.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load options');
      }
    } catch (e) {
      print('Error getting options: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePersonalInformation(
    UpdatePersonalInfoRequest request,
  ) async {
    try {
      var formData = dio.FormData.fromMap({
        ...request.toJson(),
        'api_secret': AppConstants.apiSecret,
        'user_id': request.userId,
      });

      final dioInstance = dio.Dio(
        dio.BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final response = await dioInstance.post(
        AppConstants.updatePersonalInfoEndpoint,
        data: formData,
      );

      var responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception('Failed to update personal information');
      }
    } catch (e) {
      print('Error updating personal info: $e');
      rethrow;
    }
  }

  Future<List<DropdownOption>> getThanasByDistrict(String districtId) async {
    try {
      var requestData = {
        'api_secret': AppConstants.apiSecret,
        'get-options': 'thana',
        'select-active': 'active',
        'district-id': districtId,
      };
      final response = await dio.Dio(
        dio.BaseOptions(
          baseUrl: 'https://erp.neways3.com/',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ).get('', queryParameters: requestData);

      var responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200) {
        List<dynamic> data = responseData;
        return data.map((item) => DropdownOption.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load thanas');
      }
    } catch (e) {
      print('Error getting thanas: $e');
      rethrow;
    }
  }
}
