//
//  NotificationPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import Foundation
import SwiftUI
import UserNotifications

/// Notification permission kit for managing push notification access
/// Handles notification permission requests using UserNotifications framework
@available(iOS 15.0, *)
class NotificationPermissionKit: ObservableObject, PermissionKitProtocol {
    /// Current notification authorization status
    @Published var status: UNAuthorizationStatus = .notDetermined
    
    /// Returns the permission type for this kit
    var permissionType: PermissionType {
        return .notification
    }
    
    /// Initializes the kit and refreshes current notification permission status
    init() {
        self.refreshNotificationStatus()
    }
    
    /// Updates the current notification permission status from system settings
    func refreshNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.status = settings.authorizationStatus
            }
        }
    }
    
    /// Requests notification access permission from the user
    /// Requests alert, badge, and sound notification options
    func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [.alert, .badge, .sound]
            ) { granted, error in
                self.refreshNotificationStatus()
            }
    }
    
    /// Converts UserNotifications authorization status to common AuthorizationStatus
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .authorized, .ephemeral, .provisional:
            return .granted
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            // Handle any future unknown authorization status cases
            return .notDetermined
        }
    }
    
    /// Creates a SwiftUI card for notification permission request
    /// - Parameters:
    ///   - title: Custom title for the permission card
    ///   - description: Custom description for the permission request
    ///   - onPermissionsCompleted: Callback when permission flow is completed
    /// - Returns: SwiftUI view wrapped in AnyView
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView {
        return AnyView(
            NotificationPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
