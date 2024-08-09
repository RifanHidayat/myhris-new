import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseCore
import flutter_local_notifications
import FirebaseMessaging    
import background_location_tracker
// import CorerLocation // update fake gps

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
  // update fake gps
  // private let locationManager = CLLocationManager()
  // private var isMockLocation = false
  // update fake gps sampai sini

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   
     
    GMSServices.provideAPIKey("AIzaSyC9s5juB7LHmteq7EKunhCodywTVwd0mPo")
//    SwiftFlutterForegroundTaskPlugin.setPluginRegistrantCallback(registerPlugins)
if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }


    GeneratedPluginRegistrant.register(with: self)

    BackgroundLocationTrackerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }
    
    // update fake gps
    // GeneratedPluginRegistrant.register(with: self)
    
    // let controller = window?.rootViewController as! FlutterViewController
    // let mockLocationChannel = FlutterMethodChannel(
    //   name: "com.example.mocklocation/detect",
    //   binaryMessenger: controller.binaryMessenger
    // )
    
    // mockLocationChannel.setMethodCallHandler { (call, result) in
    //   if call.method == "checkMockLocationIOS" {
    //     self.checkForMockLocation()
    //     result(self.isMockLocation)
    //   } else {
    //     result(FlutterMethodNotImplemented)
    //   }
    // }
    // update fake gps sampai sini
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application:UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken:Data){
    Messaging.messaging().apnsToken=deviceToken 
    super.application(application,didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)
  }
  // update fake gps
  // private func checkForMockLocation() {
  //   locationManager.delegate = self
  //   locationManager.requestWhenInUseAuthorization()
  //   locationManager.startUpdatingLocation()
  // }
  
  // func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  //   if let location = locations.last {
  //     if location.timestamp.timeIntervalSinceNow > 5.0 || location.horizontalAccuracy < 0 {
  //       isMockLocation = true
  //     } else {
  //       isMockLocation = false
  //     }
  //   }
  //   locationManager.stopUpdatingLocation()
  // }
  // update fake gps sampai sini
}

// here
func registerPlugins(registry: FlutterPluginRegistry) {
  GeneratedPluginRegistrant.register(with: registry)
}
