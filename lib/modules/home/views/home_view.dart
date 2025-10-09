import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sh_m/modules/home/widgets/member_status_badge.dart';
import 'package:sh_m/modules/personal_info/views/documents_screen.dart';
import 'package:sh_m/routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  String getStatusText(String status) {
    switch (status) {
      case '0':
        return 'Not Registered';
      case '1':
        return 'Registered';
      default:
        return 'Unknown';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case '1':
        return Colors.blueAccent.shade400;
      case '0':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _handleEditTap() {
    if (controller.isEditEnabled) {
      Get.toNamed('/personal-info');
    } else {
      Get.snackbar(
        'Alert',
        "Editing disabled in '${controller.getStatusText()}' status",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _handleManageDocTap() {
    if (controller.isEditEnabled) {
      Get.toNamed(AppRoutes.DOCUMENTS);
    } else {
      Get.snackbar(
        'Alert',
        "Updating documents disabled in '${controller.getStatusText()}' status",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Color _getBorderColor() {
  //   return getStatusColor(controller.userInfo.value?.status ?? '0');
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Obx(() {
                    if (controller.isLoading.value) {
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent.shade400,
                          ),
                        ),
                      );
                    }
                    return Container(
                      color: Colors.white,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  // Profile Photo
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blueAccent.shade400
                                                  .withOpacity(0.15),
                                              blurRadius: 12,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 36,
                                          backgroundColor: Colors.grey[100],
                                          backgroundImage:
                                              controller
                                                      .userInfo
                                                      .value
                                                      ?.photo !=
                                                  null
                                              ? NetworkImage(
                                                  controller
                                                      .userInfo
                                                      .value!
                                                      .photo,
                                                )
                                              : null,
                                          child:
                                              controller
                                                      .userInfo
                                                      .value
                                                      ?.photo ==
                                                  null
                                              ? Icon(
                                                  Icons.person_rounded,
                                                  size: 36,
                                                  color: Colors.grey[400],
                                                )
                                              : null,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: getStatusColor(
                                              controller
                                                      .userInfo
                                                      .value
                                                      ?.status ??
                                                  '0',
                                            ),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  // Name and Status
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.userInfo.value?.name ??
                                              'User',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                            letterSpacing: -0.5,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Wrap(
                                          children: [
                                            MemberStatusBadge(),
                                            SizedBox(width: 5),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: _handleEditTap,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        controller.isEditEnabled
                                                        ? Colors
                                                              .blueAccent
                                                              .shade400
                                                        : Colors.grey.shade600,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          controller
                                                              .isEditEnabled
                                                          ? Colors
                                                                .blueAccent
                                                                .shade400
                                                          : Colors
                                                                .grey
                                                                .shade600,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: const [
                                                      Icon(
                                                        Icons.edit_rounded,
                                                        size: 10,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'Edit Info',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.black87,
                          size: 18,
                        ),
                      ),
                      onPressed: controller.logout,
                      tooltip: 'Logout',
                    ),
                  ),
                ],
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorColor: Colors.blueAccent.shade400,
                    indicatorWeight: 2.5,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: -0.3,
                    ),
                    tabs: const [
                      Tab(text: 'PROFILE'),
                      Tab(text: 'PERSONAL'),
                      Tab(text: 'DOCUMENTS'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildProfileTab(),
              _buildPersonalTab(),
              _buildDocumentsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = controller.userInfo.value;
      if (user == null) {
        return const Center(child: Text('No user information available'));
      }

      return RefreshIndicator(
        onRefresh: () async => controller.refreshUserData(),
        color: Colors.blueAccent.shade400,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCompactCard(
                title: 'Contact Information',
                icon: Icons.alternate_email_rounded,
                children: [
                  _buildCompactRow(
                    icon: Icons.email_rounded,
                    label: 'Email',
                    value: user.email,
                  ),
                  _buildCompactRow(
                    icon: Icons.phone_rounded,
                    label: 'Phone',
                    value: user.phone,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCompactCard(
                title: 'Account Details',
                icon: Icons.badge_rounded,
                children: [
                  _buildCompactRow(
                    icon: Icons.person_rounded,
                    label: 'User Type',
                    value: user.userType,
                  ),
                  _buildCompactRow(
                    icon: Icons.credit_card_rounded,
                    label: 'ID Type',
                    value: user.identificationType,
                  ),
                  _buildCompactRow(
                    icon: Icons.numbers_rounded,
                    label: 'ID Number',
                    value: user.identificationNumber,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildVerificationCard(user),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVerificationCard(dynamic user) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade400.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: Colors.blueAccent.shade400,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Verification Status',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildVerificationItem(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  isVerified: user.emailVerify == '1',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildVerificationItem(
                  icon: Icons.phone_android_rounded,
                  label: 'Phone',
                  isVerified: user.phoneVerify == '1',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationItem({
    required IconData icon,
    required String label,
    required bool isVerified,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isVerified
            ? Colors.green.withOpacity(0.05)
            : Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isVerified
              ? Colors.blueAccent.shade400.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isVerified ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isVerified ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isVerified ? 'Verified' : 'Pending',
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final personal = controller.personalInfo.value;
      if (personal == null) {
        return RefreshIndicator(
          onRefresh: () async => controller.refreshUserData(),
          color: Colors.blueAccent.shade400,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: Get.height - 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_off_rounded,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No personal information available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Please complete your personal info',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.PERSONAL_INFO);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade400,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.edit_rounded, color: Colors.white),
                      tooltip: 'Add Personal Info',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => controller.refreshUserData(),
        color: Colors.blueAccent.shade400,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // _buildEditButton(),
              // const SizedBox(height: 12),
              _buildCompactCard(
                title: 'Basic Information',
                icon: Icons.person_rounded,
                children: [
                  _buildCompactRow(
                    icon: Icons.badge_rounded,
                    label: 'Full Name',
                    value: personal.memberName,
                  ),
                  _buildCompactRow(
                    icon: Icons.family_restroom_rounded,
                    label: 'Father\'s Name',
                    value: personal.fatherName,
                  ),
                  _buildCompactRow(
                    icon: Icons.cake_rounded,
                    label: 'Date of Birth',
                    value: personal.dateOfBirth,
                  ),
                  _buildCompactRow(
                    icon: Icons.wc_rounded,
                    label: 'Gender',
                    value: personal.genderName,
                  ),
                  _buildCompactRow(
                    icon: Icons.water_drop_rounded,
                    label: 'Blood Group',
                    value: personal.bloodGroupName,
                  ),
                  _buildCompactRow(
                    icon: Icons.mosque_rounded,
                    label: 'Religion',
                    value: personal.religionName,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCompactCard(
                title: 'Professional & Education',
                icon: Icons.work_rounded,
                children: [
                  _buildCompactRow(
                    icon: Icons.business_center_rounded,
                    label: 'Occupation',
                    value: personal.occupationName,
                  ),
                  _buildCompactRow(
                    icon: Icons.school_rounded,
                    label: 'Education',
                    value: personal.educationName,
                  ),
                  _buildCompactRow(
                    icon: Icons.favorite_rounded,
                    label: 'Marital Status',
                    value: personal.maritalName,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCompactCard(
                title: 'Location Details',
                icon: Icons.location_on_rounded,
                children: [
                  _buildCompactRow(
                    icon: Icons.public_rounded,
                    label: 'Country',
                    value: personal.countryName,
                  ),
                  _buildCompactRow(
                    icon: Icons.map_rounded,
                    label: 'Division',
                    value: personal.divisionName,
                  ),
                  _buildCompactRow(
                    icon: Icons.location_city_rounded,
                    label: 'District',
                    value: personal.districtName,
                  ),
                  _buildCompactRow(
                    icon: Icons.place_rounded,
                    label: 'Thana',
                    value: personal.thanaName,
                  ),
                  _buildCompactRow(
                    icon: Icons.home_rounded,
                    label: 'Address',
                    value: personal.address,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCompactCard(
                title: 'Emergency Contact',
                icon: Icons.emergency_rounded,
                children: [
                  _buildCompactRow(
                    icon: Icons.people_rounded,
                    label: 'Relation',
                    value: personal.relationName,
                  ),
                  _buildCompactRow(
                    icon: Icons.person_rounded,
                    label: 'Contact Name',
                    value: personal.contactName,
                  ),
                  _buildCompactRow(
                    icon: Icons.phone_rounded,
                    label: 'Contact Number',
                    value: personal.contactNumber,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCompactCard(
                title: 'Other Information',
                icon: Icons.info_rounded,
                children: [
                  _buildCompactRow(
                    icon: Icons.language_rounded,
                    label: 'Source',
                    value: personal.findUsName,
                  ),
                  _buildCompactRow(
                    icon: Icons.note_rounded,
                    label: 'Note',
                    value: personal.note,
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDocumentsTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      String _formatDate(String dateStr) {
        try {
          final date = DateTime.parse(dateStr);
          final months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
          return '${months[date.month - 1]} ${date.day}, ${date.year}';
        } catch (e) {
          return dateStr;
        }
      }

      bool _isImageFile(String filename) {
        final ext = filename.toLowerCase();
        return ext.endsWith('.jpg') ||
            ext.endsWith('.jpeg') ||
            ext.endsWith('.png');
      }

      final documents = controller.documentInfo;
      if (documents.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async => controller.refreshUserData(),
          color: Colors.blueAccent.shade400,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: Get.height - 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.description_rounded,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No documents available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Upload documents to get started',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.DOCUMENTS);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade400,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.add_rounded, color: Colors.white),
                      tooltip: 'Upload Document',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => controller.refreshUserData(),
        color: Colors.blueAccent.shade400,
        child: Column(
          children: [
            SizedBox(height: 8),
            Material(
              child: InkWell(
                onTap: () => _handleManageDocTap(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: controller.isEditEnabled
                        ? Colors.blueAccent.shade400
                        : Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: controller.isEditEnabled
                          ? Colors.blueAccent.shade400
                          : Colors.grey.shade600,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.manage_accounts,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Manage Documents',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  final isImage = _isImageFile(doc.attachment);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Get.to(() => DocumentViewScreen(document: doc));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isImage
                                      ? Colors.blueAccent.shade400.withOpacity(
                                          0.1,
                                        )
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isImage
                                      ? Icons.image_outlined
                                      : Icons.insert_drive_file_rounded,
                                  color: isImage
                                      ? Colors.blueAccent.shade400
                                      : Colors.orange,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.documentTypeName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black87,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatDate(doc.createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey[600],
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  // Widget _buildEditButton() {
  //   return Container(
  //     width: double.infinity,
  //     height: 48,
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.blueAccent.shade400.withOpacity(0.25),
  //           blurRadius: 8,
  //           offset: const Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         borderRadius: BorderRadius.circular(12),
  //         onTap: () {
  //           Get.toNamed('/personal-info');
  //         },
  //         child: const Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.edit_rounded, color: Colors.white, size: 18),
  //             SizedBox(width: 8),
  //             Text(
  //               'Edit Personal Info',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //                 letterSpacing: -0.3,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCompactCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade400.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.blueAccent.shade400, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCompactRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  value.isEmpty ? 'N/A' : value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: Colors.grey[100], height: 1, thickness: 1),
      ],
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
