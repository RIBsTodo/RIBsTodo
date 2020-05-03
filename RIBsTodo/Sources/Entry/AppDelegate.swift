//
//  AppDelegate.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol UrlHandler: class {
  func handle(_ url: URL)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  private var launchRouter: LaunchRouting?
  private var urlHandler: UrlHandler?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let result = RootBuilder(dependency: AppComponent()).build()
    let launchRouter = result.launchRouter
    self.launchRouter = launchRouter
    self.urlHandler = result.urlHandler
    launchRouter.launch(from: window)
    
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
  
  public func application(
    _ application: UIApplication,
    open url: URL,
    sourceApplication: String?,
    annotation: Any
  ) -> Bool {
    self.urlHandler?.handle(url)
    return true
  }
}
