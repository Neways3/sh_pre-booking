import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sh_m/data/models/member_status_response.dart';
import 'package:sh_m/data/models/user_info_model.dart';
import 'package:sh_m/modules/home/services/home_service.dart';
import '../../../data/models/user_model.dart';
import '../../../services/storage_service.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final HomeService _apiService = HomeService();
  final user = Rxn<User>();

  final isLoading = false.obs;
  final userInfo = Rx<UserInfo?>(null);
  final personalInfo = Rx<PersonalInfo?>(null);
  final documentInfo = <DocumentInfo>[].obs;

  // NEW: Member status properties
  final memberStatusResponse = Rx<MemberStatusResponse?>(null);
  final isStatusLoading = false.obs;
  final statusError = ''.obs;

  // Get AuthController safely
  AuthController? get authController {
    try {
      return Get.find<AuthController>();
    } catch (e) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    loadMemberStatus(); // NEW: Load member status on init
  }

  // Load user information
  Future<void> loadUserInfo() async {
    try {
      isLoading.value = true;

      final user = StorageService.getUser();
      if (user?.id == null) {
        Get.snackbar('Error', 'User ID not found');
        return;
      }

      final response = await _apiService.getUserInfo(user!.id);

      if (response.status == 'success') {
        userInfo.value = response.userInfo;
        personalInfo.value = response.personalInfo;
        documentInfo.value = response.documentInfo ?? [];
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to load user information',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error loading user info: $e');
      Get.snackbar(
        'Error',
        'Failed to load user information: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // NEW: Load member status
  Future<void> loadMemberStatus() async {
    try {
      isStatusLoading.value = true;
      statusError.value = '';

      final user = StorageService.getUser();
      if (user?.id == null) {
        statusError.value = 'User ID not found';
        return;
      }

      final response = await _apiService.getMemberStatus(user!.id);
      memberStatusResponse.value = response;

      if (!response.isSuccess) {
        statusError.value = response.message ?? 'Failed to fetch status';
      }
    } catch (e) {
      debugPrint('Error loading member status: $e');
      statusError.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isStatusLoading.value = false;
    }
  }

  String getStatusText() {
    return memberStatusResponse.value?.memberStatus ?? 'Unknown';
  }

  Color getStatusColor() {
    if (memberStatusResponse.value?.memberStatus == null) return Colors.grey;

    final statusType = MemberStatusType.fromString(
      memberStatusResponse.value!.memberStatus!,
    );

    switch (statusType) {
      case MemberStatusType.booked:
        return const Color(0xFF2196F3);
      case MemberStatusType.occupied:
        return const Color(0xFF4CAF50);
      case MemberStatusType.canceled:
      case MemberStatusType.autoCanceled:
        return const Color(0xFFE53935);
      case MemberStatusType.checkoutNotBooked:
        return const Color(0xFFFF9800);
      case MemberStatusType.notBooked:
      default:
        return const Color(0xFF757575);
    }
  }

  IconData getStatusIcon() {
    if (memberStatusResponse.value?.memberStatus == null) {
      return Icons.help_outline;
    }

    final statusType = MemberStatusType.fromString(
      memberStatusResponse.value!.memberStatus!,
    );

    switch (statusType) {
      case MemberStatusType.booked:
        return Icons.bookmark;
      case MemberStatusType.occupied:
        return Icons.home;
      case MemberStatusType.canceled:
      case MemberStatusType.autoCanceled:
        return Icons.cancel;
      case MemberStatusType.checkoutNotBooked:
        return Icons.logout;
      case MemberStatusType.notBooked:
      default:
        return Icons.bookmark_border;
    }
  }

  bool get isEditEnabled => memberStatusResponse.value?.isEditEnabled ?? false;

  Future refreshMemberStatus() async {
    await loadMemberStatus();
  }

  void refreshUserData() {
    loadUserInfo();
    loadMemberStatus();
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    final auth = authController;
    if (auth != null) {
      auth.logout();
    } else {
      // Fallback logout if controller not found
      StorageService.logout();
      Get.snackbar('Success', 'Logged out successfully');
      Get.offAllNamed('/login');
    }
  }
}
