//
//  NotificationViewController.swift
//  SampleList
//
//  Created by Lavanya on 20/08/18.
//  Copyright © 2018 Tailwebs. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController,UNUserNotificationCenterDelegate {
  @IBOutlet weak var createButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound,.carPlay],completionHandler:  { didAllow, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            if didAllow {
                print("Permission granted")
            } else {
                print("Permission not granted")
            }
            
        })
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler( [.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
   
    @IBAction func  notificationButtonClicked(sender:Any){
        let content = UNMutableNotificationContent()
        content.title = "sample notification"
        content.subtitle = "Ios sample notify"
        content.body = "IOS developemnt location notification smaple check"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "Sample IOS Notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
