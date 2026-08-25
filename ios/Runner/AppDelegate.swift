import UIKit
import Flutter
import GoogleMaps
import Firebase 

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {


    FirebaseApp.configure()

    // ✅ Initialize Google Maps safely
    GMSServices.provideAPIKey("REPLACE_WITH_GOOGLE_API_KEY")

    // ✅ Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // ✅ Call super AFTER everything is set up
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
