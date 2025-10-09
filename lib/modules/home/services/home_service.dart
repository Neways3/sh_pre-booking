import 'dart:convert';
import 'package:get/get.dart' hide FormData;
import 'package:sh_m/core/constants/app_constants.dart';
import 'package:sh_m/data/models/member_status_response.dart';
import 'package:sh_m/data/models/user_info_model.dart';
import '../../../services/api_service.dart';

class HomeService extends GetxService {
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

  // NEW: Get member status
  Future<MemberStatusResponse> getMemberStatus(String userId) async {
    try {
      final response = await _apiService.post(
        AppConstants.memberStatusEndpoint, // Add this to your AppConstants
        includeUserId: true,
      );

      var responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200) {
        return MemberStatusResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to load member status');
      }
    } catch (e) {
      print('Error getting member status: $e');
      rethrow;
    }
  }
}
