// controllers/personal_info_controller.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sh_m/data/models/user_info_model.dart';
import 'package:sh_m/modules/home/controllers/home_controller.dart';
import 'package:sh_m/modules/personal_info/services/personal_info_service.dart';
import 'package:sh_m/routes/app_routes.dart';
import 'package:sh_m/services/storage_service.dart';

class PersonalInfoController extends GetxController {
  final PersonalInfoService _apiService = PersonalInfoService();

  // Loading states
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final isLoadingOptions = false.obs;
  final isLoadingThanas = false.obs;

  // User data
  final userInfo = Rx<UserInfo?>(null);
  final personalInfo = Rx<PersonalInfo?>(null);
  final documentInfo = <DocumentInfo>[].obs;

  final imageBase64 = ''.obs;

  // Form controllers
  final fatherNameController = TextEditingController();
  final addressController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final noteController = TextEditingController();

  // Selected values
  final selectedGender = Rx<DropdownOption?>(null);
  final selectedFindUs = Rx<DropdownOption?>(null);
  final selectedOccupation = Rx<DropdownOption?>(null);
  final selectedReligion = Rx<DropdownOption?>(null);
  final selectedBloodGroup = Rx<DropdownOption?>(null);
  final selectedDistrict = Rx<DropdownOption?>(null);
  final selectedThana = Rx<DropdownOption?>(null);
  final selectedEmergencyRelation = Rx<DropdownOption?>(null);
  final selectedMaritalStatus = Rx<DropdownOption?>(null);
  final selectedEducation = Rx<DropdownOption?>(null);

  // Dropdown options
  final genderOptions = <DropdownOption>[].obs;
  final findUsOptions = <DropdownOption>[].obs;
  final occupationOptions = <DropdownOption>[].obs;
  final religionOptions = <DropdownOption>[].obs;
  final bloodGroupOptions = <DropdownOption>[].obs;
  final districtOptions = <DropdownOption>[].obs;
  final thanaOptions = <DropdownOption>[].obs;
  final emergencyRelationOptions = <DropdownOption>[].obs;
  final maritalStatusOptions = <DropdownOption>[].obs;
  final educationOptions = <DropdownOption>[].obs;

  // Selected photo
  final selectedPhoto = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // Data loading flags
  final isDataLoaded = false.obs;
  final isOptionsLoaded = false.obs;

  // Document-related observables (add after existing observables)
  final documentTypeOptions = <DropdownOption>[].obs;

  final homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    // Dispose controllers
    fatherNameController.dispose();
    addressController.dispose();
    contactNameController.dispose();
    contactNumberController.dispose();
    dateOfBirthController.dispose();
    noteController.dispose();
    super.onClose();
  }

  Future<void> _initializeData() async {
    try {
      // Load dropdown options first
      await loadDropdownOptions();
      // Then load user info
      await loadUserInfo();
    } catch (e) {
      debugPrint('Error initializing data: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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
        documentInfo.value = response.documentInfo!;

        if (isOptionsLoaded.value) {
          await _populateFormFields();
        } else {
          ever(isOptionsLoaded, (loaded) async {
            if (loaded) {
              await _populateFormFields();
            }
          });
        }

        isDataLoaded.value = true;
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

  Future<void> loadDropdownOptions() async {
    if (isOptionsLoaded.value) return;

    try {
      isLoadingOptions.value = true;

      final futures = [
        _loadOptionsSafely('gender'),
        _loadOptionsSafely('find-us'),
        _loadOptionsSafely('occupations'),
        _loadOptionsSafely('religions'),
        _loadOptionsSafely('blood-group'),
        _loadOptionsSafely('district'),
        _loadOptionsSafely('emergency-ralation'),
        _loadOptionsSafely('marital-status'),
        _loadOptionsSafely('education-lavel'),
        _loadOptionsSafely('documents-type'),
      ];

      final results = await Future.wait(futures);

      genderOptions.assignAll(results[0]);
      findUsOptions.assignAll(results[1]);
      occupationOptions.assignAll(results[2]);
      religionOptions.assignAll(results[3]);
      bloodGroupOptions.assignAll(results[4]);
      districtOptions.assignAll(results[5]);
      districtOptions.sort(
        (a, b) => a.text.toString().compareTo(b.text.toString()),
      );
      emergencyRelationOptions.assignAll(results[6]);
      maritalStatusOptions.assignAll(results[7]);
      educationOptions.assignAll(results[8]);
      documentTypeOptions.assignAll(results[9]);

      isOptionsLoaded.value = true;

      debugPrint('Dropdown options loaded successfully');
    } catch (e) {
      debugPrint('Error loading dropdown options: $e');
      Get.snackbar(
        'Error',
        'Failed to load dropdown options: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingOptions.value = false;
    }
  }

  Future<List<DropdownOption>> _loadOptionsSafely(String endpoint) async {
    try {
      final options = await _apiService.getOptions(endpoint);
      debugPrint('Loaded ${options.length} options for $endpoint');
      return options;
    } catch (e) {
      debugPrint('Error loading options for $endpoint: $e');
      return <DropdownOption>[];
    }
  }

  Future<void> loadThanas(String districtId) async {
    if (districtId.isEmpty) {
      thanaOptions.clear();
      selectedThana.value = null;
      return;
    }

    try {
      isLoadingThanas.value = true;
      selectedThana.value = null;

      debugPrint('Loading thanas for district: $districtId');
      final thanas = await _apiService.getThanasByDistrict(districtId);

      thanaOptions.assignAll(thanas);
      thanaOptions.sort(
        (a, b) => a.text.toString().compareTo(b.text.toString()),
      );
      debugPrint('Loaded ${thanas.length} thanas');
    } catch (e) {
      debugPrint('Error loading thanas: $e');
      thanaOptions.clear();
      Get.snackbar(
        'Error',
        'Failed to load thanas: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingThanas.value = false;
    }
  }

  Future<void> _populateFormFields() async {
    final personal = personalInfo.value;
    if (personal == null) {
      debugPrint('No personal info to populate');
      return;
    }

    debugPrint('Populating form fields...');

    // Populate text fields
    fatherNameController.text = personal.fatherName ?? '';
    addressController.text = personal.address ?? '';
    contactNameController.text = personal.contactName ?? '';
    contactNumberController.text = personal.contactNumber ?? '';
    dateOfBirthController.text = personal.dateOfBirth ?? '';
    noteController.text = personal.note ?? '';

    // Set selected dropdown values
    selectedGender.value = _findOptionById(genderOptions, personal.genderId);
    selectedFindUs.value = _findOptionById(findUsOptions, personal.findUsId);
    selectedOccupation.value = _findOptionById(
      occupationOptions,
      personal.occupationId,
    );
    selectedReligion.value = _findOptionById(
      religionOptions,
      personal.religionId,
    );
    selectedBloodGroup.value = _findOptionById(
      bloodGroupOptions,
      personal.bloodGroupId,
    );
    selectedEmergencyRelation.value = _findOptionById(
      emergencyRelationOptions,
      personal.relationId,
    );
    selectedMaritalStatus.value = _findOptionById(
      maritalStatusOptions,
      personal.maritalId,
    );
    selectedEducation.value = _findOptionById(
      educationOptions,
      personal.educationId,
    );

    // Handle district and thana with proper sequencing
    if (personal.districtId?.isNotEmpty == true) {
      selectedDistrict.value = _findOptionById(
        districtOptions,
        personal.districtId!,
      );

      // Load thanas for the selected district and then set the selected thana
      if (selectedDistrict.value != null) {
        await loadThanas(personal.districtId!);

        // Set selected thana after thanas are loaded
        if (personal.thanaId?.isNotEmpty == true) {
          selectedThana.value = _findOptionById(
            thanaOptions,
            personal.thanaId!,
          );
          debugPrint('Set selected thana: ${selectedThana.value?.text}');
        }
      }
    }

    debugPrint('Form fields populated successfully');
  }

  DropdownOption? _findOptionById(List<DropdownOption> options, String? id) {
    if (id == null || id.isEmpty || options.isEmpty) return null;

    try {
      final option = options.firstWhere((option) => option.id == id);
      return option;
    } catch (e) {
      debugPrint('Option not found for ID: $id in ${options.length} options');
      return null;
    }
  }

  void onDistrictChanged(DropdownOption? district) {
    selectedDistrict.value = district;
    selectedThana.value = null;
    thanaOptions.clear();

    if (district != null) {
      loadThanas(district.id);
    }
  }

  Future<void> pickPhoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        final cropped = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 500,
          maxHeight: 500,
          compressQuality: 90,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Photo',
              lockAspectRatio: true,
            ),
            IOSUiSettings(aspectRatioLockEnabled: true),
          ],
        );

        if (cropped != null) {
          final croppedFile = File(cropped.path);
          selectedPhoto.value = File(cropped.path);

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
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showPhotoPickerOptions() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Get.back();
                  pickPhoto(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Get.back();
                  pickPhoto(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Validate form
  bool _validateForm() {
    final validations = [
      (fatherNameController.text.trim().isEmpty, 'Father Name is required!'),
      (selectedGender.value == null, 'Gender is required!'),
      (selectedFindUs.value == null, 'Find Us is required!'),
      (selectedOccupation.value == null, 'Occupation is required!'),
      (selectedReligion.value == null, 'Religion is required!'),
      (selectedBloodGroup.value == null, 'Blood Group is required!'),
      (selectedDistrict.value == null, 'District is required!'),
      (selectedThana.value == null, 'Thana is required!'),
      (
        selectedEmergencyRelation.value == null,
        'Emergency Contact Relation is required!',
      ),
      (selectedMaritalStatus.value == null, 'Marital Status is required!'),
      (selectedEducation.value == null, 'Education is required!'),
      (addressController.text.trim().isEmpty, 'Address is required!'),
      (contactNameController.text.trim().isEmpty, 'Contact Name is required!'),
      (
        contactNumberController.text.trim().isEmpty,
        'Contact Number is required!',
      ),
      (
        contactNumberController.text.trim().length < 11,
        'Contact Number must 11 character!',
      ),
      (dateOfBirthController.text.trim().isEmpty, 'Date of Birth is required!'),
      // (imageBase64.value.isEmpty, 'Photo is required!'),
    ];

    for (final validation in validations) {
      if (validation.$1) {
        Get.snackbar('Error', validation.$2);
        return false;
      }
    }
    return true;
  }

  Future<void> updatePersonalInfo() async {
    if (!_validateForm()) return;

    final userId = userInfo.value?.id;
    if (userId == null) {
      Get.snackbar('Error', 'User ID not found');
      return;
    }

    await homeController.refreshMemberStatus();
    if (!homeController.isEditEnabled) {
      Get.snackbar(
        'Error',
        "Upadating blocked in '${homeController.getStatusText()}' status",
      );
      return;
    }

    try {
      isUpdating.value = true;

      final request = UpdatePersonalInfoRequest(
        userId: userId,
        fatherName: fatherNameController.text.trim(),
        genderId: selectedGender.value!.id,
        findUsId: selectedFindUs.value!.id,
        occupationId: selectedOccupation.value!.id,
        religionId: selectedReligion.value!.id,
        bloodGroupId: selectedBloodGroup.value!.id,
        districtId: selectedDistrict.value!.id,
        thanaId: selectedThana.value!.id,
        emergencyContactRelation: selectedEmergencyRelation.value!.id,
        maritalId: selectedMaritalStatus.value!.id,
        educationId: selectedEducation.value!.id,
        address: addressController.text.trim(),
        contactName: contactNameController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        dateOfBirth: dateOfBirthController.text.trim(),
        note: noteController.text.trim(),
        editMemberFinalPhoto: imageBase64.value.isNotEmpty
            ? imageBase64.value
            : null,
      );

      final response = await _apiService.updatePersonalInformation(request);

      if (response['status'] == 'success') {
        await Future.wait([
          loadUserInfo(),
          homeController.loadUserInfo(),
          homeController.refreshMemberStatus(),
        ]).catchError((error) {
          debugPrint('Error reloading data: $error');
        });

        selectedPhoto.value = null;
        imageBase64.value = '';

        Get.offAllNamed(AppRoutes.HOME);

        Get.snackbar(
          'Success',
          response['message'] ?? 'Information updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update information',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('Error updating personal info: $e');
      Get.snackbar(
        'Error',
        'Failed to update information: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> selectDateOfBirth(BuildContext context) async {
    final currentDate = DateTime.now();
    final currentDateOfBirth = dateOfBirthController.text.isNotEmpty
        ? DateTime.tryParse(dateOfBirthController.text)
        : null;

    final selectedDate = await showDatePicker(
      locale: Locale('en', 'GB'),
      context: context,
      initialDate: currentDateOfBirth ?? DateTime(currentDate.year - 17),
      firstDate: DateTime(1900),
      lastDate: DateTime(currentDate.year - 17),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      dateOfBirthController.text =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    }
  }

  void resetForm() {
    fatherNameController.clear();
    addressController.clear();
    contactNameController.clear();
    contactNumberController.clear();
    dateOfBirthController.clear();
    noteController.clear();

    selectedGender.value = null;
    selectedFindUs.value = null;
    selectedOccupation.value = null;
    selectedReligion.value = null;
    selectedBloodGroup.value = null;
    selectedDistrict.value = null;
    selectedThana.value = null;
    selectedEmergencyRelation.value = null;
    selectedMaritalStatus.value = null;
    selectedEducation.value = null;
    selectedPhoto.value = null;
    imageBase64.value = '';

    thanaOptions.clear();
  }

  Future<void> refreshData() async {
    isDataLoaded.value = false;
    isOptionsLoaded.value = false;
    await _initializeData();
  }
}
