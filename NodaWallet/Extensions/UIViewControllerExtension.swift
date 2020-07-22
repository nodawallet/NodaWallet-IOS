//
//  UIViewControllerExtension.swift
//  BaseArchitect

import Foundation
import UIKit
import BitcoinKit

extension UIViewController {
    
    func pushViewController(identifier: String, storyBoardName: String) {
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController(identifier: String, storyBoardName: String) {
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        self.present(vc, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithOkAction(title: String, message: String, okAction: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancelAndOk(title: String, okAction: UIAlertAction) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alert) in
            
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertOkAction(message: String, okAction: UIAlertAction) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushSlideMenuController(identifier: String, storyBoardName: String) {
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        self.slideMenuController()?.closeLeft()
        self.slideMenuController()?.closeRight()
        (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(vc, animated: true)
    }
    
//    func showTabbarController(identifier: String, storyBoardName: String, index: Int) {
//        let storyBoard = UIStoryboard(name: storyBoardName, bundle: Bundle.main)
//        let vc = storyBoard.instantiateViewController(withIdentifier: identifier) as! HomeTabbarControllerViewController
//        vc.selectedIndex = index
//        self.slideMenuController()?.closeLeft()
//        self.slideMenuController()?.closeRight()
//        (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(vc, animated: true)
//    }
    
    func popUpView(message: String) {
        if message.count > 0 {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    public func sendNotification(notificationMsg: String) {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                print("notDetermined")
                break
            // Request Authorization
            case .authorized:
                self.scheduleLocalNotification(msg: notificationMsg)
                break
            // Schedule Local Notification
            case .denied:
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                break
                
            }
        }
    
    }
    
    public func scheduleLocalNotification(msg: String) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = myAppName
        //notificationContent.subtitle = "Local Notifications"
        notificationContent.body = msg
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func convertToSatoshi(value: Decimal) -> Int {
        let coinRate: Decimal = pow(10, 8)
        let coinValue: Decimal = value * coinRate
        let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return NSDecimalNumber(decimal: coinValue).rounding(accordingToBehavior: handler).intValue
    }
    
    func isValidBitcoinAddress(address: String) -> Bool {
        do {
            let addr = try BitcoinAddress(legacy: address)
            return true
        } catch(let err) {
            return false
        }
    }
    
    func convertedUsingDecimal(priceInDouble: Double, decimal: Int) -> String {
        var decimalDivVal = "1"
        for _ in 1...decimal {
            decimalDivVal += "0"
        }
        let decimalToDivide = Double(decimalDivVal) ?? 0
        let value = priceInDouble / decimalToDivide
        return value.avoidNotation
    }
    
    func bnbAmountConvertion(priceInDouble: Double, decimal: Int) -> Int64 {
        var decimalDivVal = "1"
        for _ in 1...decimal {
            decimalDivVal += "0"
        }
        let decimalInDouble = Double(decimalDivVal)!
        let amount = priceInDouble * decimalInDouble
        return Int64(amount)
    }
    
}

extension NSObject {
    public func topMostViewController() -> UIViewController {
        return self.topMostViewController(withRootViewController: (UIApplication.shared.keyWindow?.rootViewController!)!)
    }
    public func topMostViewController(withRootViewController rootViewController: UIViewController) -> UIViewController {
        if (rootViewController is UITabBarController) {
            let tabBarController = (rootViewController as! UITabBarController)
            return self.topMostViewController(withRootViewController: tabBarController.selectedViewController!)
        } else if (rootViewController is UINavigationController) {
            let navigationController = (rootViewController as! UINavigationController)
            return self.topMostViewController(withRootViewController: navigationController.visibleViewController!)
        } else if rootViewController.presentedViewController != nil {
            let presentedViewController = rootViewController.presentedViewController!
            return self.topMostViewController(withRootViewController: presentedViewController)
        } else {
            return rootViewController
        }
        
    }
}

extension UIWindow {
    
    func topMostViewController() -> UIViewController? {
        guard let rootViewController = self.rootViewController else {
            return nil
        }
        return topViewController(for: rootViewController)
    }
    
    func topViewController(for rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        guard let presentedViewController = rootViewController.presentedViewController else {
            return rootViewController
        }
        switch presentedViewController {
        case is UINavigationController:
            let navigationController = presentedViewController as! UINavigationController
            return topViewController(for: navigationController.viewControllers.last)
        case is UITabBarController:
            let tabBarController = presentedViewController as! UITabBarController
            return topViewController(for: tabBarController.selectedViewController)
        default:
            return topViewController(for: presentedViewController)
        }
    }
    
}
