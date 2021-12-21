//
//  ViewController.swift
//  Notification
//
//  Created by Alibi on 26/07/2018.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            
            if granted {
                print("Notification access granted")
            } else {
                print(error?.localizedDescription as Any)
            }
        })
    }

    @IBAction func notifyMe(sender: UIButton) {
        scheduleNotification(inSeconds: 5, complition: {success in
            if success {
                print("Nice notif")
            } else {
                print("Error!")
            }
        })
    }
    
    func scheduleNotification(inSeconds: TimeInterval, complition: @escaping (_ Success: Bool) -> ()) {
        let image = "rick_grimes"
        guard let imageURL = Bundle.main.url(forResource: image, withExtension: "gif") else {
            complition(false)
            return
        }
        
        var attachment: UNNotificationAttachment
        attachment = try! UNNotificationAttachment(identifier: "myNotification", url: imageURL, options: .none)
        
        
        let notif = UNMutableNotificationContent()
        
        notif.categoryIdentifier = "myNotificationCategory"
        
        notif.title = "New Notification"
        notif.subtitle = "These are great"
        notif.body = "This is the start of the greatest era of technologies"
        
        notif.attachments = [attachment]
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: "myNotification", content: notif, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if error != nil {
                print(error as Any)
                complition(false)
            } else {
                complition(true)
            }
        })
    }
}














