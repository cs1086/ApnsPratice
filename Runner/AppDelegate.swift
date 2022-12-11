import UIKit
import FMDB
import sqflite
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      HttpRequest.get("AppDelegate...")
      print("filePath="+Dao.shared.filePath);
      UNUserNotificationCenter.current().delegate=self
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { success, _ in
          guard success else{
              return
          }
          print("####apns success")
      }
      application.registerForRemoteNotifications()
      print("####初始化方法")
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Token: ", deviceToken)
        
     // let chars = UnsafePointer<CChar>((deviceToken as NSData).bytes)
      var token = ""

      for i in 0..<deviceToken.count {
    //token += String(format: "%02.2hhx", arguments: [chars[i]])
       token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
      }

      print("Registration succeeded!")
      print("Token: ", token)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            //HttpRequest.get("tokenId=\(tokenId)")
        }
     }
    
    //前景收到apns推播
    override func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
            print("Handle push from foreground")
            // custom code to handle push while app is in the foreground
            print("\(notification.request.content.userInfo)")
//        ReconnectSip.register()
            //HttpRequest.get("recieve.foreground")
    }

    //背景收到apns推播
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("Handle push from background or closed")
            // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
            print("\(response.notification.request.content.userInfo)")
            
            //HttpRequest.get("recieve.background")
    }
}
