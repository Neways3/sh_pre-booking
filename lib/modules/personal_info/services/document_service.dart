import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:sh_m/core/constants/app_constants.dart';

import 'package:sh_m/data/models/document_upload_request.dart';
import 'package:sh_m/data/models/user_info_model.dart';
import 'package:sh_m/services/api_service.dart';
import 'package:sh_m/services/storage_service.dart';

// Import your existing models
// Replace 'your_app' with your actual package name
// import 'package:your_app/models/user_info_model.dart';
// import 'package:your_app/models/document_type_model.dart';

class DocumentService {
  final ApiService _apiService = Get.find<ApiService>();

  // Get document types

  Future<List<DropdownOption>> getDocumentTypes(String type) async {
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

  Future<UserInfoResponse> getUserInformation() async {
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

  Future<DocumentUploadResponse> uploadDocuments(
    DocumentUploadRequest request,
  ) async {
    try {
      final formData = FormData();

      final user = StorageService.getUser();
      if (user != null) {
        formData.fields.add(MapEntry('user_id', user.id));
      }
      formData.fields.add(MapEntry('api_secret', AppConstants.apiSecret));

      // Add document type IDs
      for (int i = 0; i < request.documentTypeIds.length; i++) {
        formData.fields.add(
          MapEntry('documents_type_id[$i]', request.documentTypeIds[i]),
        );
      }

      // Add attachments
      for (int i = 0; i < request.attachmentPaths.length; i++) {
        final file = File(request.attachmentPaths[i]);
        final fileName = file.path.split('/').last;
        final mimeType = _getMimeType(fileName);

        formData.files.add(
          MapEntry(
            'attachment[$i]',
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
              contentType: MediaType.parse(mimeType),
            ),
          ),
        );
      }

      final response = await dio.Dio(
        dio.BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ).post(AppConstants.documentUploadEndpoint, data: formData);

      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (response.statusCode == 200) {
        return DocumentUploadResponse.fromJson(responseData);
      }
      throw Exception('Failed to upload documents');
    } catch (e) {
      throw Exception('Error uploading documents: $e');
    }
  }

  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }
}
