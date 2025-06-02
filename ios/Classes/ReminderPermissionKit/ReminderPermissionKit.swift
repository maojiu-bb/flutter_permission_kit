//
//  ReminderPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//


import Foundation
import SwiftUI
import EventKit

/// Reminder permission kit for managing calendar events access
/// Handles reminder permission requests using the EventKit framework
@available(iOS 15.0, *)
class ReminderPermissionKit: ObservableObject, PermissionKitProtocol {
    /// Current calendar authorization status from EKEventStore
    @Published var status: EKAuthorizationStatus = EKEventStore.authorizationStatus(for: .reminder)
    
    /// Returns the permission type for this kit
    var permissionType: PermissionType {
        return .reminder
    }
    
    /// Requests calendar access permission from the user
    func requestPermission() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .reminder) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.status = .notDetermined
                    return
                }
                self.status = granted ? .authorized : .denied
            }
        }
    }
    
    /// Converts EKEventStore authorization status to common AuthorizationStatus
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .authorized:
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
    
    /// Creates a SwiftUI card for calendar permission request
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
            ReminderPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
