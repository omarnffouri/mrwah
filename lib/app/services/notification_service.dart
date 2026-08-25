import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Singleton pattern (optional but nice)
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  /// Used in background isolate: initialize Firebase if not already done
  static Future<void> initializeFirebaseCore() async {
    try {
      await Firebase.initializeApp();
    } catch (_) {
      // Ignore if already initialized
    }
  }

  Future<void> init() async {
    // Local notifications init (needed to show custom notifications)
    await _initLocalNotifications();

    // Request permissions (especially for iOS)
    await _requestPermissions();

    // Optionally set foreground notification presentation options (iOS)
    if (Platform.isIOS || Platform.isMacOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Your app icon

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap from local notification
        final payload = response.payload;
        // You can parse the payload JSON if you want to navigate
        debugPrint("Notification tapped with payload: $payload");
      },
    );

    // Android channel
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> _requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // iOS permission
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Android 13+ notification permission is handled by app-level runtime perms.
    // You might also want to handle it via permission_handler package.
  }

  /// Show a local notification from an FCM message
  Future<void> showNotificationFromFCM(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    // AndroidNotification? android = notification?.android;

    if (notification == null) return;

    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(
      notificationId,
      notification.title,
      notification.body,
      platformDetails,
      payload: message.data.isNotEmpty ? message.data.toString() : null,
    );
  }

  /// Handle notification tap (for navigation, etc.)
  void handleMessageTap(RemoteMessage message, {bool fromTerminated = false}) {
    // Here you can inspect message.data and navigate accordingly.
    // Example: if your data contains a route name or an item id.
    debugPrint(
      'Notification tapped. From terminated: $fromTerminated, data: ${message.data}',
    );

    // Example:
    // final route = message.data['route'];
    // if (route != null) {
    //   navigatorKey.currentState?.pushNamed(route);
    // }
  }
}
