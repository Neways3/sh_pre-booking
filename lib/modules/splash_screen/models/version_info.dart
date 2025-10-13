class VersionInfo {
  final String id;
  final String platformId;
  final String platformName;
  final String appId;
  final String appName;
  final String platformUrl;
  final String latestVersion;
  final String minimumVersion;
  final String releaseNote;
  final String forceUpdate;
  final String isTerminated;
  final String isMaintenance;
  final String notice;
  final String note;
  final String status;

  VersionInfo({
    required this.id,
    required this.platformId,
    required this.platformName,
    required this.appId,
    required this.appName,
    required this.platformUrl,
    required this.latestVersion,
    required this.minimumVersion,
    required this.releaseNote,
    required this.forceUpdate,
    required this.isTerminated,
    required this.isMaintenance,
    required this.notice,
    required this.note,
    required this.status,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      id: json['id']?.toString() ?? '',
      platformId: json['platform_id']?.toString() ?? '',
      platformName: json['platform_name']?.toString() ?? '',
      appId: json['app_id']?.toString() ?? '',
      appName: json['app_name']?.toString() ?? '',
      platformUrl: json['platform_url']?.toString() ?? '',
      latestVersion: json['current_version']?.toString() ?? '',
      minimumVersion: json['minimum_version']?.toString() ?? '',
      releaseNote: json['release_note']?.toString() ?? '',
      forceUpdate: json['force_update']?.toString() ?? '0',
      isTerminated: json['is_terminated']?.toString() ?? '0',
      isMaintenance: json['is_maintainance']?.toString() ?? '0',
      notice: json['notice']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      status: json['status']?.toString() ?? '1',
    );
  }

  bool get shouldForceUpdate => forceUpdate == '1';
  bool get isAppTerminated => isTerminated == '1';
  bool get isUnderMaintenance => isMaintenance == '1';
  bool get isActive => status == '1';
}

class VersionApiResponse {
  final String status;
  final String code;
  final VersionInfo? playStore;
  final VersionInfo? appStore;

  VersionApiResponse({
    required this.status,
    required this.code,
    this.playStore,
    this.appStore,
  });

  factory VersionApiResponse.fromJson(Map<String, dynamic> json) {
    final versionData = json['version'] as Map<String, dynamic>?;

    return VersionApiResponse(
      status: json['status']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      playStore: versionData?['PlayStore'] != null
          ? VersionInfo.fromJson(versionData!['PlayStore'])
          : null,
      appStore: versionData?['AppStore'] != null
          ? VersionInfo.fromJson(versionData!['AppStore'])
          : null,
    );
  }
}
