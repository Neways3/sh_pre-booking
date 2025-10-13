import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sh_m/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  void _launchPrivacyPolicy() async {
    final Uri url = Uri.parse(AppConstants.privacyPolicyUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFF1A1A1A),
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Profile Photo Section
              Center(
                child: Obx(
                  () => Column(
                    children: [
                      GestureDetector(
                        onTap: controller.showImagePickerOptions,
                        child: Stack(
                          children: [
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 2.5,
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: controller.selectedImage.value != null
                                  ? ClipOval(
                                      child: Image.file(
                                        controller.selectedImage.value!,
                                        fit: BoxFit.cover,
                                        width: 90,
                                        height: 90,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person_outline_rounded,
                                      size: 38,
                                      color: Colors.grey.shade400,
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade400,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFAFAFA),
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueAccent.shade400
                                          .withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.selectedImage.value != null
                            ? 'Tap to change'
                            : 'Add photo',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // if (controller.selectedImage.value != null)
                      //   TextButton(
                      //     onPressed: controller.removeSelectedImage,
                      //     style: TextButton.styleFrom(
                      //       foregroundColor: Colors.red.shade400,
                      //       padding: const EdgeInsets.symmetric(
                      //         horizontal: 12,
                      //         vertical: 4,
                      //       ),
                      //     ),
                      //     child: const Text(
                      //       'Remove',
                      //       style: TextStyle(
                      //         fontSize: 13,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Name Field
              _buildLabel('Full Name'),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.nameController,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
                decoration: _inputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline_rounded,
                ),
              ),
              const SizedBox(height: 18),

              // Phone Field with Verification
              _buildLabel('Phone Number'),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Expanded(
                      child: TextFormField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        enabled: !controller.isPhoneVerified.value,
                        maxLength: 11,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: controller.isPhoneVerified.value
                              ? Colors.grey
                              : Color(0xFF1A1A1A),
                        ),
                        decoration: _inputDecoration(
                          hintText: '01XXXXXXXXX',
                          prefixIcon: Icons.phone_outlined,
                          suffixIcon: Obx(
                            () => controller.isPhoneVerified.value
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFF10B981),
                                    size: 20,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isPhoneVerified.value
                            ? null
                            : controller.verifyPhoneForRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isPhoneVerified.value
                              ? const Color(0xFF10B981)
                              : Colors.blueAccent.shade400,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF10B981),
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                        ),
                        child: controller.isOtpLoading.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                controller.isPhoneVerified.value
                                    ? 'Verified'
                                    : 'Verify',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Email Field
              _buildLabel('Email'),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
                decoration: _inputDecoration(
                  hintText: 'your@email.com',
                  prefixIcon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 18),

              // Identification Type Dropdown
              _buildLabel('Identification Type'),
              const SizedBox(height: 10),
              Obx(
                () => DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  value: controller.selectedIdentificationType.value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                  decoration: _inputDecoration(
                    hintText: 'Select ID type',
                    prefixIcon: Icons.badge_outlined,
                  ),
                  items: ['NID', 'Passport', 'Driving License']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedIdentificationType.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 18),

              // Identification Number Field
              _buildLabel('Identification Number'),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.identificationNumberController,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
                decoration: _inputDecoration(
                  hintText: 'Enter ID number',
                  prefixIcon: Icons.credit_card_outlined,
                ),
              ),
              const SizedBox(height: 18),

              // Password Field
              _buildLabel('Password'),
              const SizedBox(height: 10),
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade500,
                        size: 20,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.blueAccent.shade400,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Confirm Password Field
              _buildLabel('Confirm Password'),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
                decoration: _inputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                ),
              ),
              const SizedBox(height: 22),

              // Verification Notice
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: controller.isPhoneVerified.value
                        ? const Color(0xFFF0FDF4)
                        : Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: controller.isPhoneVerified.value
                          ? const Color(0xFFBBF7D0)
                          : Colors.amber.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        controller.isPhoneVerified.value
                            ? Icons.check_circle_outline_rounded
                            : Icons.info_outline_rounded,
                        color: controller.isPhoneVerified.value
                            ? const Color(0xFF10B981)
                            : Colors.amber.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.isPhoneVerified.value
                              ? 'Phone verified successfully'
                              : 'Verify phone number to continue',
                          style: TextStyle(
                            color: controller.isPhoneVerified.value
                                ? const Color(0xFF065F46)
                                : Colors.amber.shade900,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Text.rich(
                TextSpan(
                  text: 'By creating account, you are agree to our ',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _launchPrivacyPolicy,
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Register Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        (controller.isLoading.value ||
                            !controller.isPhoneVerified.value)
                        ? null
                        : controller.submitRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade400,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(prefixIcon, color: Colors.grey.shade500, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.blueAccent.shade400, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    );
  }
}
