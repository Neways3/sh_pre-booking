import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sh_m/data/models/user_info_model.dart';
import 'package:sh_m/modules/personal_info/controllers/document_controller.dart';
import 'package:sh_m/modules/personal_info/views/documents_screen.dart';
import '../controllers/personal_info_controller.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalInfoController());
    final documentController = Get.put(DocumentController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Edit Personal Info',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 22),
          onPressed: () => Get.back(),
        ),
        // actions: [
        // IconButton(
        //   icon: const Icon(Icons.refresh_rounded, size: 20),
        //   onPressed: () => controller.refreshData(),
        //   tooltip: 'Refresh',
        // ),
        // ],
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller.isLoadingOptions.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.blueAccent.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading your profile...',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              ],
            ),
          );
        }

        if (!controller.isDataLoaded.value &&
            !controller.isOptionsLoaded.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 56,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 14),
                Text(
                  'Unable to load data',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshData(),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          color: Colors.blueAccent.shade400,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildPhotoHeader(controller),
                _buildFormContent(controller, documentController),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: _buildFloatingActions(controller),
    );
  }

  Widget _buildPhotoHeader(PersonalInfoController controller) {
    return Obx(
      () => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => controller.showPhotoPickerOptions(),
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _getPhotoImage(controller) == null
                          ? LinearGradient(
                              colors: [
                                Colors.blueAccent.shade400,
                                Colors.blueAccent.shade400,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      image: _getPhotoImage(controller),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _getPhotoImage(controller) == null
                        ? const Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade400,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
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
              'Tap to change photo',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(
    PersonalInfoController controller,
    DocumentController documentController,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSection(
            icon: Icons.person_outline_rounded,
            title: 'Personal',
            children: [
              _buildTextField(
                controller: controller.fatherNameController,
                label: "Father's Name",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                value: controller.selectedGender.value,
                items: controller.genderOptions,
                label: 'Gender',
                icon: Icons.wc_rounded,
                onChanged: (value) => controller.selectedGender.value = value,
              ),
              const SizedBox(height: 12),
              _buildDatePickerField(
                controller: controller.dateOfBirthController,
                label: 'Date of Birth',
                icon: Icons.cake_rounded,
                onTap: () => controller.selectDateOfBirth(Get.context!),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.phone_rounded,
            title: 'Contact',
            children: [
              _buildDropdownField(
                value: controller.selectedFindUs.value,
                items: controller.findUsOptions,
                label: 'How did you find us?',
                icon: Icons.search_rounded,
                onChanged: (value) => controller.selectedFindUs.value = value,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: controller.contactNameController,
                label: 'Emergency Contact Name',
                icon: Icons.contact_phone_rounded,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: controller.contactNumberController,
                label: 'Emergency Contact Number',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                maxLength: 11,
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                value: controller.selectedEmergencyRelation.value,
                items: controller.emergencyRelationOptions,
                label: 'Relation',
                icon: Icons.people_rounded,
                onChanged: (value) =>
                    controller.selectedEmergencyRelation.value = value,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.work_outline_rounded,
            title: 'Professional',
            children: [
              _buildDropdownField(
                value: controller.selectedOccupation.value,
                items: controller.occupationOptions,
                label: 'Occupation',
                icon: Icons.business_center_rounded,
                onChanged: (value) =>
                    controller.selectedOccupation.value = value,
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                value: controller.selectedEducation.value,
                items: controller.educationOptions,
                label: 'Education Level',
                icon: Icons.school_rounded,
                onChanged: (value) =>
                    controller.selectedEducation.value = value,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.info_outline_rounded,
            title: 'Details',
            children: [
              _buildDropdownField(
                value: controller.selectedReligion.value,
                items: controller.religionOptions,
                label: 'Religion',
                icon: Icons.brightness_5_rounded,
                onChanged: (value) => controller.selectedReligion.value = value,
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                value: controller.selectedBloodGroup.value,
                items: controller.bloodGroupOptions,
                label: 'Blood Group',
                icon: Icons.water_drop_rounded,
                onChanged: (value) =>
                    controller.selectedBloodGroup.value = value,
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                value: controller.selectedMaritalStatus.value,
                items: controller.maritalStatusOptions,
                label: 'Marital Status',
                icon: Icons.favorite_border_rounded,
                onChanged: (value) =>
                    controller.selectedMaritalStatus.value = value,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.location_on_rounded,
            title: 'Location',
            children: [
              _buildDropdownField(
                value: controller.selectedDistrict.value,
                items: controller.districtOptions,
                label: 'District',
                icon: Icons.location_city_rounded,
                onChanged: (value) => controller.onDistrictChanged(value),
              ),
              const SizedBox(height: 12),
              Obx(
                () => _buildDropdownField(
                  value: controller.selectedThana.value,
                  items: controller.thanaOptions,
                  label: 'Thana',
                  icon: Icons.pin_drop_rounded,
                  isLoading: controller.isLoadingThanas.value,
                  onChanged: (value) => controller.selectedThana.value = value,
                ),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: controller.addressController,
                label: 'Address',
                icon: Icons.home_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSection(
            icon: Icons.note_rounded,
            title: 'Additional',
            children: [
              _buildTextField(
                controller: controller.noteController,
                label: 'Note (Optional)',
                icon: Icons.edit_note_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDocumentsSection(documentController),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: Colors.blueAccent.shade400,
                  ),
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueAccent.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade500),
        suffixIcon: Icon(
          Icons.calendar_today_rounded,
          size: 16,
          color: Colors.grey.shade500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueAccent.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required DropdownOption? value,
    required List<DropdownOption> items,
    required String label,
    required IconData icon,
    required Function(DropdownOption?) onChanged,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField<DropdownOption>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<DropdownOption>(
            value: item,
            child: Text(item.text, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: isLoading ? null : onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
        icon: isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.blueAccent.shade400,
                ),
              )
            : Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade500,
                size: 20,
              ),
        isExpanded: true,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        elevation: 8,
      ),
    );
  }

  Widget _buildDocumentsSection(DocumentController documentController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.description_rounded,
                        size: 16,
                        color: Colors.blueAccent.shade400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Documents',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => Get.toNamed('/documents'),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Manage', style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent.shade400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          documentController.userDocuments.isEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          size: 32,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No documents found',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton.icon(
                          onPressed: () => Get.toNamed('/documents'),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Add Documents'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blueAccent.shade400,
                            backgroundColor: Colors.blueAccent.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Column(
                    children: documentController.userDocuments.map((doc) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () =>
                                Get.to(DocumentViewScreen(document: doc)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file_rounded,
                                    color: Colors.grey.shade400,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      doc.documentTypeName,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.grey.shade400,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions(PersonalInfoController controller) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.isUpdating.value
                      ? null
                      : () => _showConfirmationModal(controller),
                  icon: controller.isUpdating.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded, size: 18),
                  label: Text(
                    controller.isUpdating.value ? 'Saving...' : 'Save Changes',
                    style: const TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DecorationImage? _getPhotoImage(PersonalInfoController controller) {
    if (controller.selectedPhoto.value != null) {
      return DecorationImage(
        image: FileImage(controller.selectedPhoto.value!),
        fit: BoxFit.cover,
      );
    } else if (controller.userInfo.value?.photo.isNotEmpty == true) {
      return DecorationImage(
        image: NetworkImage(controller.userInfo.value!.photo),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  void _showResetConfirmation(PersonalInfoController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reset Form?',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        content: const Text(
          'All your changes will be lost. This action cannot be undone.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.resetForm();
              Get.snackbar(
                'Success',
                'Form has been reset',
                backgroundColor: Colors.blueAccent.shade400,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
                borderRadius: 10,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationModal(PersonalInfoController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Colors.blueAccent.shade400,
              ),
              const SizedBox(height: 14),
              const Text(
                'Confirm Changes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to update your personal information? '
                'These changes will be applied to your profile.',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  height: 1.4,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  controller.updatePersonalInfo();
                },
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text(
                  'Yes, Save Changes',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
