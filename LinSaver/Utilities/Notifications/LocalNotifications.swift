//
//  Notifications.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 07/06/24.
//

import Foundation
import UserNotifications

class LocalNotifications: ObservableObject{
    

    func scheduleTrialEndingNotification(for subscription: LocalSubscription) {
        guard let endDate = subscription.endDate else { return }
        let notifyDate = Calendar.current.date(byAdding: .day, value: -2, to: endDate)!
        
        let content = UNMutableNotificationContent()
        content.title = "Trial Ending Soon"
        content.body = "Your trial period will end in 2 days. Don't forget to subscribe!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notifyDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: subscription.id!.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }

}
