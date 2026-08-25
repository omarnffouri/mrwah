import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/langs/app_translation.dart';
import 'package:mrwah/app/services/notification_service.dart';
import 'package:mrwah/app/services/storage_service.dart';
import 'app/routes/app_pages.dart';

// DI
import 'app/services/injection_service.dart' as di;

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// ------------------------------------------------------
/// FCM BACKGROUND HANDLER (VERY IMPORTANT RULES APPLY)
/// ------------------------------------------------------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService().showNotificationFromFCM(message);
}

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ------------------------
    // Local storage
    // ------------------------
    await di.initLocalDb();

    // ------------------------
    // Firebase (MUST be before DI that may touch Firebase)
    // ------------------------
    await Firebase.initializeApp();

    // ------------------------
    // Dependency Injection
    // ------------------------
    await di.init();

    // ------------------------
    // Background FCM handler
    // ------------------------
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    // ------------------------
    // Notification service (FOREGROUND only)
    // ------------------------
    await NotificationService().init();

    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      // FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      debugPrint(errorDetails.exceptionAsString());
    };

    runApp(const Application());
  }, (e, st) {
    // FirebaseCrashlytics.instance.recordError(e, st, fatal: true);
    debugPrint('Error: $e\nStackTrace: $st');
  });
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();
    _initFCMListeners();
  }

  /// ------------------------------------------------------
  /// FCM FOREGROUND + TAP HANDLERS (SAFE)
  /// ------------------------------------------------------
  void _initFCMListeners() {
    final messaging = FirebaseMessaging.instance;

    // Get FCM token (for backend later)
    messaging.getToken().then((token) {
      debugPrint('🔥 FCM Token: $token');
    });

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService().showNotificationFromFCM(message);
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationService().handleMessageTap(message);
    });

    // App opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        NotificationService().handleMessageTap(
          message,
          fromTerminated: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String code = StorageService.langCode;

    return ScreenUtilInit(
      designSize: const Size(428, 926),
      child: GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        translations: AppTranslations(),
        locale: Locale(code),
        fallbackLocale: const Locale('en'),
      ),
    );
  }
}
