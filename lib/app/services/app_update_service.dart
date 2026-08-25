import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  AppUpdateService({
    NewVersionPlus? newVersion,
    String? iOSAppId,
  })  : _iosAppId = iOSAppId ?? _defaultIOSAppId,
        _newVersion = newVersion ??
            NewVersionPlus(
              androidId: _androidPackageId,
              iOSId: (iOSAppId ?? _defaultIOSAppId).isEmpty
                  ? null
                  : (iOSAppId ?? _defaultIOSAppId),
            );

  static const String _androidPackageId = 'com.mrwah.app';
  static const String _defaultIOSAppId = '6755366404';

  final NewVersionPlus _newVersion;
  final String _iosAppId;

  bool get _shouldSkipIOSCheck =>
      Platform.isIOS && (_iosAppId.isEmpty || _iosAppId.trim().isEmpty);

  Future<VersionStatus?> getLatestStatus() async {
    if (kIsWeb) return null;
    if (_shouldSkipIOSCheck) {
      debugPrint('Skipping iOS update check: missing App Store ID.');
      return null;
    }

    try {
      return await _newVersion.getVersionStatus();
    } catch (e) {
      debugPrint('Failed to fetch version info: $e');
      return null;
    }
  }

  Future<void> openStoreListing(VersionStatus status) async {
    final link = status.appStoreLink;
    if (link.isEmpty) {
      debugPrint('No store link found for update redirect.');
      return;
    }

    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $link');
    }
  }
}
