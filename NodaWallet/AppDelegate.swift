//
//  AppDelegate.swift
//  NodaWallet
//
//  n 06/03/20.
//  .
//

import UIKit
import SwiftTheme
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import AVFoundation
//App delegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Thread.sleep(forTimeInterval: 2.0)
        IQKeyboardManager.shared.enable = true
    
        let getMode = UserDefaults.standard.value(forKey: Constants.UserDefaultKey.isDarkModeSelected)
        if let isDarkMode = getMode as? Bool {
            if isDarkMode {
                Constants.User.isDarkMode = true
                ThemeManager.setTheme(index: 1)
            } else {
                Constants.User.isDarkMode = false
                ThemeManager.setTheme(index: 0)
            }
        }
        
        //Get Camera Permission
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                Constants.User.accessCamera = true
            } else {
                Constants.User.accessCamera = false
            }
        }
        
        return true
    }
    
    func homepage() {
        if let userSelectedCurrencyVal = UserDefaults.standard.string(forKey: Constants.UserDefaultKey.userSelectedCurrencyID) {
            userSelectedCurrency = userSelectedCurrencyVal
        }
        
        if let userSelectedCurrencySymbolVal = UserDefaults.standard.string(forKey: Constants.UserDefaultKey.userSelectedCurrencySymbolID) {
            userSelectedCurrencySymbol = userSelectedCurrencySymbolVal
        }
        let mainPage = Constants.storyBoard.Main.instantiateViewController(withIdentifier:"LandingTabbarControllerID") as! LandingTabbarController
        window?.rootViewController? = mainPage
        window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

/*extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        // Process notification content
        print("notify msges\(content.userInfo)")
        completionHandler([.alert, .sound])
    }
}*/
