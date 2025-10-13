import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sh_m/data/models/document_upload_request.dart';
import 'package:sh_m/data/models/user_info_model.dart';
import 'package:sh_m/modules/home/controllers/home_controller.dart';

import 'package:sh_m/modules/personal_info/services/document_service.dart';

class DocumentController extends GetxController {
  final DocumentService _documentService = DocumentService();

  final documentTypes = <DropdownOption>[].obs;
  final userDocuments = <DocumentInfo>[].obs;
  final selectedDocuments = <DocumentUploadItem>[].obs;
  final isLoading = false.obs;
  final isUploading = false.obs;

  final homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    try {
      await Future.wait([loadDocumentTypes(), loadUserDocuments()]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDocumentTypes() async {
    try {
      final types = await _documentService.getDocumentTypes('documents-type');
      documentTypes.value = types;
    } catch (e) {
      throw Exception('Failed to load document types: $e');
    }
  }

  Future<void> loadUserDocuments() async {
    try {
      final response = await _documentService.getUserInformation();
      userDocuments.value = response.documentInfo ?? [];
    } catch (e) {
      throw Exception('Failed to load user documents: $e');
    }
  }

  void addDocument(DropdownOption type) {
    selectedDocuments.add(
      DocumentUploadItem(documentType: type, filePath: null),
    );
  }

  void removeDocument(int index) {
    selectedDocuments.removeAt(index);
  }

  Future<void> pickImageFromGallery(int index) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedDocuments[index].filePath = image.path;
        selectedDocuments.refresh();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickImageFromCamera(int index) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedDocuments[index].filePath = image.path;
        selectedDocuments.refresh();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickFile(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        selectedDocuments[index].filePath = result.files.single.path;
        selectedDocuments.refresh();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showFilePickerOptions(int index) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Get.back();
                  pickImageFromGallery(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Take Photo'),
                onTap: () {
                  Get.back();
                  pickImageFromCamera(index);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.insert_drive_file,
                  color: Colors.orange,
                ),
                title: const Text('Choose Document'),
                onTap: () {
                  Get.back();
                  pickFile(index);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Validate and upload documents
  // Future<void> uploadDocuments() async {
  //   // Validation
  //   if (selectedDocuments.isEmpty) {
  //     Get.snackbar(
  //       'Validation Error',
  //       'Please add at least one document',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     return;
  //   }

  //   for (int i = 0; i < selectedDocuments.length; i++) {
  //     if (selectedDocuments[i].filePath == null) {
  //       Get.snackbar(
  //         'Validation Error',
  //         'Please select a file for ${selectedDocuments[i].documentType.text}',
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //       return;
  //     }
  //   }

  //   await homeController.refreshMemberStatus();
  //   if (!homeController.isEditEnabled) {
  //     Get.snackbar(
  //       'Error',
  //       "Uploading blocked in '${homeController.getStatusText()}' status",
  //     );
  //     return;
  //   }

  //   isUploading.value = true;
  //   try {
  //     final request = DocumentUploadRequest(
  //       documentTypeIds: selectedDocuments
  //           .map((doc) => doc.documentType.id)
  //           .toList(),
  //       attachmentPaths: selectedDocuments.map((doc) => doc.filePath!).toList(),
  //     );

  //     final response = await _documentService.uploadDocuments(request);

  //     if (response.isSuccess) {
  //       Get.snackbar(
  //         'Success',
  //         response.message,
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //       );
  //       selectedDocuments.clear();
  //       await loadUserDocuments();
  //     } else {
  //       Get.snackbar(
  //         'Error',
  //         response.message,
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to upload documents: ${e.toString()}',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isUploading.value = false;
  //   }
  // }

  Future<void> uploadDocuments() async {
    // Validation
    if (selectedDocuments.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please add at least one document',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    for (final doc in selectedDocuments) {
      if (doc.filePath == null) {
        Get.snackbar(
          'Validation Error',
          'Please select a file for ${doc.documentType.text}',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    await homeController.refreshMemberStatus();
    if (!homeController.isEditEnabled) {
      Get.snackbar(
        'Error',
        "Uploading blocked in '${homeController.getStatusText()}' status",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isUploading.value = true;

    try {
      final request = DocumentUploadRequest(
        documentTypeIds: selectedDocuments
            .map((d) => d.documentType.id)
            .toList(),
        attachmentPaths: selectedDocuments.map((d) => d.filePath!).toList(),
      );

      final response = await _documentService.uploadDocuments(request);

      if (response.isSuccess) {
        selectedDocuments.clear();
        await loadUserDocuments();

        await homeController.loadUserInfo();

        Get.back();
        await Future.delayed(const Duration(milliseconds: 200));

        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload documents: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // Get available document types (not already uploaded)
  // List<DropdownOption> getAvailableDocumentTypes() {
  //   final uploadedTypeIds = userDocuments
  //       .map((doc) => doc.documentTypeId)
  //       .toSet();
  //   final selectedTypeIds = selectedDocuments
  //       .map((doc) => doc.documentType.id)
  //       .toSet();

  //   return documentTypes.where((type) {
  //     return !uploadedTypeIds.contains(type.id) &&
  //         !selectedTypeIds.contains(type.id);
  //   }).toList();
  // }
}

// Helper class for document upload items
class DocumentUploadItem {
  final DropdownOption documentType;
  String? filePath;

  DocumentUploadItem({required this.documentType, this.filePath});
}
