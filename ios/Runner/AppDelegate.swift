import UIKit
import Flutter
import GoogleMaps


// AppDelegate.m #import <FBSDKCoreKit/FBSDKCoreKit.h> - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { [[ApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions]; // Add any custom logic here. return YES; } - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options { BOOL handled = [[ApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey] ]; // Add any custom logic here. return handled; }


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
      GMSServices.provideAPIKey("AIzaSyBwDB1i6FveSGC0rFar4ZYcJM3xacQqZ1g")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
