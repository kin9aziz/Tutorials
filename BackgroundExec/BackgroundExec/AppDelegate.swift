//
//  AppDelegate.swift
//  BackgroundExec
//
//  Created by Quang Tran on 2/7/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTaskID: UIBackgroundTaskIdentifier?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Fetch data once an hour.
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)

        return true
    }
    
    func fetchUpdates() -> [String: Any]? {
        print("Fetch updates")
        return ["Key 1": "Value 1"]
    }
    
    func addDataToFeed(newData: [String: Any]) {
        print("Added data to feed")
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Check for new data.
        if let newData = fetchUpdates() {
            addDataToFeed(newData: newData)
            completionHandler(.newData)
        }
        completionHandler(.noData)
    }
    
    func sendDataToServer( data : Data ) {
        // Perform the task on a background queue.
        DispatchQueue.global().async {
            // Request the task assertion and save the ID.
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Finish Network Tasks") {
                // End the task if time expires.
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
            
            // Send the data synchronously.
            self.sendAppDataToServer( data: data)
            
            // End the task assertion.
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    func sendAppDataToServer(data: Data) {
        print("Sent app data to server")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Application did enter background")
        
        // Time remaining to exec any task such as send data to server
        let timeRemaining = UIApplication.shared.backgroundTimeRemaining
        print("Time remaining: \(timeRemaining)")
        
        let data = "string".data(using: String.Encoding.utf8)
        self.sendDataToServer(data: data!)
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

