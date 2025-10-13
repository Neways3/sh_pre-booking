import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sh_m/core/constants/app_constants.dart';
import 'package:sh_m/modules/splash_screen/models/version_info.dart';
import 'package:sh_m/routes/app_routes.dart';
import 'package:sh_m/services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreenController extends GetxController {
  var isLoading = false.obs;

  bool _updateDialogShown = false;
  bool _navigationCompleted = false;

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  void initializeApp() async {
    try {
      // Actually wait for the delay
      await Future.delayed(const Duration(seconds: 1));

      bool updateRequired = await checkForUpdate();

      if (!updateRequired && !_updateDialogShown) {
        _navigateToNextScreen();
      }
    } catch (e) {
      print("Initialization error: $e");
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    if (_navigationCompleted) return;
    _navigationCompleted = true;

    final user = StorageService.getUser();
    if (user != null) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  Future<bool> checkForUpdate() async {
    var context = Get.context;
    if (context == null) return false;

    try {
      isLoading.value = true;

      dio.FormData formData = dio.FormData.fromMap({
        "api_secret":
            "kAXan6SFy5U3UrzHMMQgCzFEHwU9jzuBF6kbsFMjRsCSY8fFVhwhRTZvBqrMbcK3",
        "app_id": 3,
      });
      dio.Response response = await dio.Dio().post(
        AppConstants.versionUpgradeUrl,
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic> jsonData;

        if (response.data is String) {
          try {
            jsonData = json.decode(response.data);
          } catch (e) {
            return false;
          }
        } else if (response.data is Map<String, dynamic>) {
          jsonData = response.data;
        } else {
          return false;
        }

        final apiResponse = VersionApiResponse.fromJson(jsonData);

        if (apiResponse.status != 'success') {
          return false;
        }

        final VersionInfo? versionInfo = Platform.isAndroid
            ? apiResponse.playStore
            : apiResponse.appStore;

        if (versionInfo == null) {
          return false;
        }

        if (versionInfo.isAppTerminated) {
          await showMaintenanceDialog(
            context,
            "App Terminated",
            "This app has been discontinued. Please contact support.",
          );
          return true;
        }

        if (versionInfo.isUnderMaintenance) {
          await showMaintenanceDialog(
            context,
            "Under Maintenance",
            versionInfo.notice.isNotEmpty
                ? versionInfo.notice
                : "The app is currently under maintenance. Please try again later.",
          );
          return true;
        }

        if (!versionInfo.isActive) {
          // print("App version is not active");
          return false;
        }

        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;

        final cmpLatest = compareVersions(
          currentVersion,
          versionInfo.latestVersion,
        );
        final cmpMinimum = compareVersions(
          currentVersion,
          versionInfo.minimumVersion,
        );

        if (cmpLatest < 0) {
          bool isForceUpdate = versionInfo.shouldForceUpdate || cmpMinimum < 0;
          await showUpdateDialog(context, isForceUpdate, versionInfo);
          return isForceUpdate;
        }

        return false;
      } else {
        // print("Failed to fetch version info: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // print("Version check failed: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showMaintenanceDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    if (_updateDialogShown) return;
    _updateDialogShown = true;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      exit(0);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Close App",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showUpdateDialog(
    BuildContext context,
    bool forceUpdate,
    VersionInfo versionInfo,
  ) async {
    if (_updateDialogShown) return;
    _updateDialogShown = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: !forceUpdate,
      barrierColor: Colors.black54,
      builder: (_) => PopScope(
        canPop: !forceUpdate,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: forceUpdate
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Icon(
                    forceUpdate
                        ? Icons.priority_high_rounded
                        : Icons.system_update_rounded,
                    size: 32,
                    color: forceUpdate ? Colors.orange : Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  forceUpdate ? "Update Required" : "Update Available",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  forceUpdate
                      ? "A new version is required to continue using the app."
                      : "A newer version is available with improvements and bug fixes.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (versionInfo.latestVersion.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Latest Version: ${versionInfo.latestVersion}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (versionInfo.releaseNote.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "What's New:",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            versionInfo.releaseNote,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    if (!forceUpdate) ...[
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _updateDialogShown = false;
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Later",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: forceUpdate ? 1 : 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          final uri = Uri.parse(versionInfo.platformUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                            // exit(0);
                          }
                          if (!forceUpdate) {
                            Navigator.pop(context);
                            _updateDialogShown = false;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: forceUpdate
                              ? Colors.orange
                              : Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Update Now",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // After dialog is dismissed (only for non-force updates)
    if (!forceUpdate && !_navigationCompleted) {
      _navigateToNextScreen();
    }
  }

  int compareVersions(String v1, String v2) {
    List<int> a = v1.split('.').map(int.parse).toList();
    List<int> b = v2.split('.').map(int.parse).toList();

    while (a.length < 3) a.add(0);
    while (b.length < 3) b.add(0);

    for (int i = 0; i < 3; i++) {
      if (a[i] != b[i]) return a[i].compareTo(b[i]);
    }
    return 0;
  }
}
