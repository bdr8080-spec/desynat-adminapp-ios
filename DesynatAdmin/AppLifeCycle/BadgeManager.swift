//
//  BadgeManager.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 26/03/26.
//


import UserNotifications

class BadgeManager {
    
    private static let badgeKey = "app_badge_count"
    
    /// Returns the current saved badge count
    static var current: Int {
        UserDefaults.standard.integer(forKey: badgeKey)
    }
    
    /// Saves badge count
    private static func save(_ value: Int) {
        UserDefaults.standard.set(value, forKey: badgeKey)
    }
    
    /// Increase badge by 1
    static func increase() {
        let newValue = current + 1
        save(newValue)
        UNUserNotificationCenter.current().setBadgeCount(newValue, withCompletionHandler: nil)
    }
    
    /// Reset badge to zero
    static func reset() {
        save(0)
        UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: nil)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}