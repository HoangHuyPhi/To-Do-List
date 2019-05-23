//
//  ItemModel.swift
//  Checklist
//
//  Created by Phi Hoang Huy on 3/4/19.
//  Copyright © 2019 Phi Hoang Huy. All rights reserved.
//

import Foundation
import UserNotifications
class ItemModel: NSObject, Codable {
    var ischecked = false
    var itemName = ""
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    override init() {
        itemID = DataModel.nextCheckListItemID()
        super.init()
    }
    deinit {
        removeNotification()
    }
}
extension ItemModel {
    func toggleItemChecked() {
        ischecked = !ischecked
    }
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = itemName
            content.sound = UNNotificationSound.default
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}

