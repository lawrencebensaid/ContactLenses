//
//  LocalNotification.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 6/1/22.
//

import Foundation
import UserNotifications

class LocalNotification {
    
    enum Status {
        case delivered, pending, all
    }
    
    private let content = UNMutableNotificationContent()
    
    public init(title: String = "Lenses", subtitle: String? = nil, body: String? = nil, identifier: String = "notification", interuption: UNNotificationInterruptionLevel = .active, attatchments: [UNNotificationAttachment] = []) {
        content.title = title
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        if let body = body {
            content.body = body
        }
        content.interruptionLevel = interuption
        content.categoryIdentifier = identifier
        content.attachments = attatchments
    }
    
    public func schedule(_ date: Date) {
        schedule(date.timeIntervalSinceNow)
    }
    
    public func schedule(_ interval: TimeInterval) {
        guard interval > 0 else { debugPrint("time interval must be greater than 0"); return }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    public static func remove(_ status: Status, with identifiers: [String] = []) {
        let notificationCenter = UNUserNotificationCenter.current()
        if status == .all || status == .delivered {
            if identifiers.isEmpty {
                notificationCenter.removeAllDeliveredNotifications()
            } else {
                notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
            }
        }
        if status == .all || status == .pending {
            if identifiers.isEmpty {
                notificationCenter.removeAllPendingNotificationRequests()
            } else {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
            }
        }
    }
    
}
