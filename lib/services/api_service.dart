import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:sh_m/core/constants/app_constants.dart';
import 'storage_service.dart';

class ApiService extends GetxService {
  late Dio _dio;
  final String baseUrl =
      AppConstants.apiBaseUrl; // Replace with your actual API URL
  final String apiSecret = AppConstants.apiSecret; // Add your API secret

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    // Add interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool includeApiSecret = true,
    bool includeUserId = false,
  }) async {
    try {
      // Create FormData
      FormData formData = FormData();

      // Add api_secret if required
      if (includeApiSecret) {
        formData.fields.add(MapEntry('api_secret', apiSecret));
      }

      // Add user_id if required and available
      if (includeUserId) {
        final user = StorageService.getUser();
        if (user != null) {
          formData.fields.add(MapEntry('user_id', user.id));
        }
      }

      // Add all other data as form fields
      if (data != null) {
        data.forEach((key, value) {
          if (value != null) {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });
      }

      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool includeApiSecret = true,
    bool includeUserId = false,
  }) async {
    try {
      // For GET requests, add api_secret and user_id to query parameters
      Map<String, dynamic> finalQueryParams = queryParameters ?? {};

      if (includeApiSecret) {
        finalQueryParams['api_secret'] = apiSecret;
      }

      if (includeUserId) {
        final user = StorageService.getUser();
        if (user != null) {
          finalQueryParams['user_id'] = user.id;
        }
      }

      final response = await _dio.get(path, queryParameters: finalQueryParams);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
