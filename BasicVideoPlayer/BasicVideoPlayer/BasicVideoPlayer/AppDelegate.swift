//
//  AppDelegate.swift
//  BasicVideoPlayer
//
//  Created by Quang Tran on 2/11/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.playback, mode: .moviePlayback)
    }
    catch {
      print("Setting category to AVAudioSessionCategoryPlayback failed.")
    }
    
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    let viewController = window?.rootViewController as! ViewController
    viewController.disconnectAVPlayer()
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    let viewController = window?.rootViewController as! ViewController
    viewController.reconnectAVPlayer()
  }
  
}
