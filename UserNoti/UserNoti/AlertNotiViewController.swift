//
//  AlertNotiViewController.swift
//  UserNoti
//
//  Created by Quang Tran on 2/1/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import UserNotifications

class AlertNotiViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var deviceTokenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func showDeviceToken(_ sender: Any) {
        let notificationCenter = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
        }
    }
    
    @IBAction func scheduleALocalNotification(_ sender: Any) {
        let notificationCenter = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.getNotificationSettings { (settings) in
                // Do not schedule notifications if not authorized.
                guard settings.authorizationStatus == .authorized else {return}
                
                if settings.alertSetting == .enabled {
                    // Schedule an alert-only notification.
                    self.scheduleMeetingNotification()
                    notificationCenter.delegate = self
                }
                else {
                    // Schedule a notification with a badge and sound.
                    
                }
            }
        }
    }
    
    private func scheduleMeetingNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Staff Meeting"
        content.body = "Every Tuesday at 2pm"
        content.badge = 3
        content.userInfo = [
            "MEETING_ID" : "123456789",
            "USER_ID" : "ABCD1234"
        ]
        content.categoryIdentifier = "MEETING_INVITATION"
        
        // Create the trigger as a repeating event.
        //        // Configure the recurring date.
        //        var dateComponents = DateComponents()
        //        dateComponents.calendar = Calendar.current
        //        dateComponents.weekday = 3  // Tuesday
        //        dateComponents.hour = 14    // 14:00 hours
        //
        //        // Create the trigger as a repeating event.
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
                print(error!)
            }
            else {
//                print("The request has been created")
                DispatchQueue.main.async {
                    self.infoLabel.text = "The notification will be shown in next 10 seconds.\nPress Home button to move the app into background mode."
                }
            }
        }
        
//         Define the custom actions.
        let acceptAction = UNNotificationAction(
            identifier: "ACCEPT_ACTION",
            title: "Accept",
            options: UNNotificationActionOptions(rawValue: 0))
        let acceptWithNoteAction = UNTextInputNotificationAction(
            identifier: "ACCEPT_WITH_NOTE_ACTION",
            title: "Accept with Note",
            options: UNNotificationActionOptions(rawValue: 0))
        let declineAction = UNNotificationAction(
            identifier: "DECLINE_ACTION",
            title: "Decline",
            options: UNNotificationActionOptions(rawValue: 0))
        
        // Define the notification type
        let meetingInviteCategory =
            UNNotificationCategory(
                identifier: "MEETING_INVITATION",
                actions: [acceptAction, acceptWithNoteAction, declineAction],
                intentIdentifiers: [],
                hiddenPreviewsBodyPlaceholder: "",
                options: .customDismissAction)
        
        // Register the notification type.
        notificationCenter.setNotificationCategories([meetingInviteCategory])
        notificationCenter.delegate = self
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Get the meeting ID from the original notification.
//        let userInfo = response.notification.request.content.userInfo
//        let meetingID = userInfo["MEETING_ID"] as! String
//        let userID = userInfo["USER_ID"] as! String
        
        // Perform the task associated with the action.
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            print("accept meeting")
            break
        case "ACCEPT_WITH_NOTE_ACTION":
            if let textResponse = response as? UNTextInputNotificationResponse {
                let note =  textResponse.userText
                print("Received note message: \(note)")
            }
            break
        case "DECLINE_ACTION":
            print("decline meeting")
            break
        // This case will be called if user tap on the notification
        case UNNotificationDefaultActionIdentifier:
            print("default action")
            break
         // This case will be called if user pull down the notification after that tap close button at top right of the notification
        case UNNotificationDismissActionIdentifier:
            print("dismiss action")
            break
        default:
            break
        }
        
        // Always call the completion handler when done.
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.content.categoryIdentifier == "MEETING_INVITATION" {
            // Retrieve the meeting details.
//            let meetingID = notification.request.content.userInfo["MEETING_ID"] as! String
//            let userID = notification.request.content.userInfo["USER_ID"] as! String
            
            // Play a sound to let the user know about the invitation.
            completionHandler(.sound)
            return
        }
        else {
            // Handle other notification types...
        }
        
        // Don't alert the user for other types.
        completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
}
