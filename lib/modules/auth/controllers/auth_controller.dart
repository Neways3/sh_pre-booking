// app/modules/auth/controllers/auth_controller.dart - Updated with Fixed OTP Flow
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sh_m/core/constants/app_constants.dart';
import '../../../data/models/login_request.dart';
import '../../../data/models/registration_request.dart';
import '../../../data/models/otp_request.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'package:dio/dio.dart' as dio;

class AuthController extends GetxController {
  final AuthService _authService = Get.put(AuthService());
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final isLoading = false.obs;
  final isOtpLoading = false.obs;
  final isLoggedIn = false.obs;
  final obscurePassword = true.obs;

  // Image related
  final selectedImage = Rx<File?>(null);
  final imageBase64 = ''.obs;

  // Registration form controllers
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController identificationNumberController;
  final selectedIdentificationType = 'NID'.obs;

  // Login form controllers
  late final TextEditingController loginPhoneController;
  late final TextEditingController loginPasswordController;

  // OTP related
  late final TextEditingController otpController;
  final currentUserId = ''.obs;
  final currentUserPhone = ''.obs;
  final generatedOtp = ''.obs;
  final isPhoneVerified = false.obs;
  final otpVerificationType = ''.obs;

  // Forgot Password related
  late final TextEditingController forgotPasswordPhoneController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmNewPasswordController;
  final isForgotPasswordLoading = false.obs;
  final isResetPasswordLoading = false.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final forgotPasswordUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    checkLoginStatus();
  }

  void _initializeControllers() {
    // Registration controllers
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    identificationNumberController = TextEditingController();

    // Login controllers
    loginPhoneController = TextEditingController();
    loginPasswordController = TextEditingController();

    // OTP controller
    otpController = TextEditingController();

    // Forgot Password controllers
    forgotPasswordPhoneController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        await _processSelectedImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: ${e.toString()}');
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        await _processSelectedImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to select image: ${e.toString()}');
    }
  }

  Future<void> _processSelectedImage(File imageFile) async {
    try {
      final cropped = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 500,
        maxHeight: 500,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
          ),
          IOSUiSettings(aspectRatioLockEnabled: true),
        ],
      );

      if (cropped != null) {
        final croppedFile = File(cropped.path);
        selectedImage.value = croppedFile;

        final bytes = await croppedFile.readAsBytes();
        final base64String = base64Encode(bytes);

        final extension = croppedFile.path.split('.').last.toLowerCase();
        String mimeType;

        switch (extension) {
          case 'png':
            mimeType = 'image/png';
            break;
          case 'jpg':
          case 'jpeg':
            mimeType = 'image/jpeg';
            break;
          case 'gif':
            mimeType = 'image/gif';
            break;
          case 'webp':
            mimeType = 'image/webp';
            break;
          default:
            mimeType = 'image/jpeg';
        }

        imageBase64.value = 'data:$mimeType;base64,$base64String';

        Get.snackbar(
          'Success',
          'Image cropped and selected successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Cancelled', 'Image cropping cancelled by user');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImageFromCamera();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Camera'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImageFromGallery();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Gallery'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void removeSelectedImage() {
    selectedImage.value = null;
    imageBase64.value = '';
  }

  void checkLoginStatus() {
    isLoggedIn.value = StorageService.isLoggedIn();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> sendForgotPasswordOtp() async {
    if (forgotPasswordPhoneController.text.isEmpty) {
      Get.snackbar('Error', 'Phone number is required');
      return;
    }
    if (forgotPasswordPhoneController.text.length < 11) {
      Get.snackbar('Error', 'Phone number must be 11 character');
      return;
    }

    isForgotPasswordLoading.value = true;

    try {
      final request = OtpRequest(phone: forgotPasswordPhoneController.text);
      final response = await _authService.getForgotPasswordOtp(request);

      if (response.isSuccess) {
        generatedOtp.value = response.data?['otp']?.toString() ?? '';
        currentUserPhone.value = forgotPasswordPhoneController.text;
        forgotPasswordUserId.value =
            response.data?['user_id']?.toString() ?? '';
        otpVerificationType.value = 'forgot_password';

        Get.snackbar(
          'Success',
          'OTP sent to your phone',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.toNamed(
          AppRoutes.OTP_VERIFICATION,
          arguments: {
            'phone': forgotPasswordPhoneController.text,
            'otp': generatedOtp.value,
            'type': 'forgot_password',
          },
        );
      } else {
        Get.snackbar('Error', response.message);
      }
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  Future<void> verifyPhoneForRegistration() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Phone number is required');
      return;
    }

    isOtpLoading.value = true;

    try {
      final request = OtpRequest(phone: phoneController.text);
      final response = await _authService.getRegistrationOtp(request);

      if (response.isSuccess) {
        generatedOtp.value = response.data?['otp']?.toString() ?? '';
        currentUserPhone.value = phoneController.text;
        otpVerificationType.value = 'registration';

        Get.snackbar('Success', 'OTP sent to your phone');
        Get.toNamed(
          AppRoutes.OTP_VERIFICATION,
          arguments: {
            'phone': phoneController.text,
            'otp': generatedOtp.value,
            'type': 'registration',
          },
        );
      } else {
        Get.snackbar('Error', response.message);
      }
    } finally {
      isOtpLoading.value = false;
    }
  }

  Future<void> verifyPhoneForLogin() async {
    try {
      final request = OtpRequest(phone: loginPhoneController.text);
      final response = await _authService.getRegistrationOtp(request);

      if (response.isSuccess) {
        generatedOtp.value = response.data?['otp']?.toString() ?? '';
        currentUserPhone.value = loginPhoneController.text;
        otpVerificationType.value = 'login';

        Get.snackbar('Success', 'OTP sent to your phone');
        Get.toNamed(
          AppRoutes.OTP_VERIFICATION,
          arguments: {
            'phone': loginPhoneController.text,
            'otp': generatedOtp.value,
            'type': 'login',
          },
        );
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP: ${e.toString()}');
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      Get.snackbar('Error', 'OTP is required');
      return;
    }

    if (otpController.text == AppConstants.testingOtp) {
      generatedOtp.value = AppConstants.testingOtp;
    }

    if (otpController.text != generatedOtp.value) {
      Get.snackbar('Error', 'Invalid OTP. Please try again.');
      return;
    }

    isLoading.value = true;

    try {
      if (otpVerificationType.value == 'registration') {
        isPhoneVerified.value = true;
        Get.snackbar(
          'Success',
          'Phone number verified! You can now complete registration.',
        );
        if (Get.currentRoute == AppRoutes.OTP_VERIFICATION) {
          Get.toNamed(AppRoutes.REGISTER);
          otpController.clear();
          generatedOtp.value = '';
        }
      } else if (otpVerificationType.value == 'login') {
        await completeLoginAfterOtp();
      } else if (otpVerificationType.value == 'forgot_password') {
        Get.snackbar(
          'Success',
          'OTP verified! Now set your new password.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(AppRoutes.RESET_PASSWORD);
      } else {
        final request = {
          'user_id': currentUserId.value,
          'phone': currentUserPhone.value,
        };

        final response = await _authService.verifyOtp(request);

        if (response.isSuccess) {
          Get.snackbar('Success', 'Phone number verified successfully');
          Get.offAllNamed(AppRoutes.HOME);
        } else {
          Get.snackbar('Error', response.message);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitNewPassword() async {
    if (!validateResetPasswordForm()) return;

    isResetPasswordLoading.value = true;

    try {
      final response = await _authService.submitNewPassword(
        userId: forgotPasswordUserId.value,
        newPassword: newPasswordController.text,
        confirmPassword: confirmNewPasswordController.text,
      );

      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'Password changed successfully! Please login with your new password.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Clear forms
        clearForgotPasswordForm();
        clearOtpForm();

        // Navigate to login
        Get.offAllNamed(AppRoutes.LOGIN);
      } else {
        Get.snackbar('Error', response.message);
      }
    } finally {
      isResetPasswordLoading.value = false;
    }
  }

  void clearForgotPasswordForm() {
    if (!isClosed) {
      forgotPasswordPhoneController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();
      forgotPasswordUserId.value = '';
      obscureNewPassword.value = true;
      obscureConfirmPassword.value = true;
    }
  }

  bool validateResetPasswordForm() {
    if (newPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'New password is required');
      return false;
    }
    if (confirmNewPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Confirm password is required');
      return false;
    }
    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return false;
    }
    if (newPasswordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return false;
    }
    return true;
  }

  Future<void> completeLoginAfterOtp() async {
    try {
      final request = LoginRequest(
        phone: loginPhoneController.text,
        password: loginPasswordController.text,
      );

      final response = await _authService.login(request);

      if (response.isSuccess && response.data != null) {
        StorageService.saveUser(response.data!);
        StorageService.setLoggedIn(true);
        isLoggedIn.value = true;

        Get.snackbar('Success', 'Login successful');
        Get.offAllNamed(AppRoutes.HOME);

        // otpController.clear();
        // generatedOtp.value = '';

        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            clearLoginForm();
            clearOtpForm();
          }
        });
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    }
  }

  Future<void> login() async {
    if (!validateLoginForm()) return;

    isLoading.value = true;

    try {
      final request = LoginRequest(
        phone: loginPhoneController.text,
        password: loginPasswordController.text,
      );

      final response = await _authService.login(request);

      if (response.isSuccess && response.data != null) {
        await verifyPhoneForLogin();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRegistration() async {
    if (!validateRegistrationForm()) return;

    if (!isPhoneVerified.value) {
      Get.snackbar('Error', 'Please verify your phone number first');
      return;
    }

    isLoading.value = true;

    try {
      var publicIp = '';

      final ipResponse = await dio.Dio().get(
        'https://api.ipify.org?format=json',
      );
      if (ipResponse.statusCode == 200) {
        publicIp = ipResponse.data['ip'] ?? '';
      }

      final request = RegistrationRequest(
        name: nameController.text,
        phone: phoneController.text,
        identificationType: selectedIdentificationType.value,
        identificationNumber: identificationNumberController.text,
        email: emailController.text,
        password: passwordController.text,
        memberFinalPhoto: imageBase64.value,
        ipAddress: publicIp,
      );

      final response = await _authService.submitRegistration(request);

      if (response.isSuccess) {
        if (response.data?['process'] == 'send_otp') {
          currentUserId.value = response.data?['user_id']?.toString() ?? '';
          currentUserPhone.value = response.data?['phone'] ?? '';

          // Call verify-otp API to mark user as phone verified
          final verifyRequest = {
            'user_id': currentUserId.value,
            'phone': currentUserPhone.value,
          };

          final verifyResponse = await _authService.verifyOtp(verifyRequest);

          if (verifyResponse.isSuccess) {
            Get.snackbar('Success', 'Registration completed successfully!');
            Get.offAllNamed(AppRoutes.LOGIN);
            clearRegistrationForm();
          } else {
            Get.snackbar('Error', verifyResponse.message);
          }
        } else {
          Get.snackbar('Success', response.message);
          Get.offAllNamed(AppRoutes.LOGIN);
          clearRegistrationForm();
        }
      } else {
        Get.snackbar('Error', response.message);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    StorageService.logout();
    isLoggedIn.value = false;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!isClosed) {
        clearAllForms();
      }
    });

    Get.snackbar('Success', 'Logged out successfully');
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  void clearLoginForm() {
    if (!isClosed) {
      loginPhoneController.clear();
      loginPasswordController.clear();
    }
  }

  void clearRegistrationForm() {
    if (!isClosed) {
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      identificationNumberController.clear();
      selectedIdentificationType.value = 'NID';
      selectedImage.value = null;
      imageBase64.value = '';
      isPhoneVerified.value = false;
    }
  }

  void clearOtpForm() {
    if (!isClosed) {
      otpController.clear();
      currentUserId.value = '';
      currentUserPhone.value = '';
      generatedOtp.value = '';
      otpVerificationType.value = '';
    }
  }

  void clearAllForms() {
    clearLoginForm();
    clearRegistrationForm();
    clearOtpForm();
    clearForgotPasswordForm();
  }

  bool validateRegistrationForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Name is required');
      return false;
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Phone is required');
      return false;
    }
    if (phoneController.text.length < 11) {
      Get.snackbar('Error', 'Phone number must be 11 digits');
      return false;
    }
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return false;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Password is required');
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return false;
    }
    if (identificationNumberController.text.isEmpty) {
      Get.snackbar('Error', 'Identification number is required');
      return false;
    }
    if (imageBase64.value.isEmpty) {
      Get.snackbar('Error', 'Profile photo is required');
      return false;
    }
    return true;
  }

  bool validateLoginForm() {
    if (loginPhoneController.text.isEmpty) {
      Get.snackbar('Error', 'Phone is required');
      return false;
    }
    if (loginPhoneController.text.length < 11) {
      Get.snackbar('Error', 'Phone number must be 11 digits');
      return false;
    }
    if (loginPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Password is required');
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    try {
      nameController.dispose();
      phoneController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
      identificationNumberController.dispose();
      loginPhoneController.dispose();
      loginPasswordController.dispose();
      otpController.dispose();
      forgotPasswordPhoneController.dispose();
      newPasswordController.dispose();
      confirmNewPasswordController.dispose();
    } catch (e) {
      print('Error disposing controllers: $e');
    }
    super.onClose();
  }
}
