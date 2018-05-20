//
//  AppDelegate.swift
//  TestPreview
//
//  Created by Kristaps Grinbergs on 09/05/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = WKWebViewController()
//    let viewController = UIWebViewController()
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
    
    return true
  }
}
