//
//  CalendarPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//


import Foundation
import SwiftUI
import EventKit

/// Calendar permission kit for managing calendar events access
/// Handles calendar permission requests using the EventKit framework
@available(iOS 15.0, *)
class CalendarPermissionKit: ObservableObject, PermissionKitProtocol {
    /// Current calendar authorization status from EKEventStore
    @Published var status: EKAuthorizationStatus = EKEventStore.authorizationStatus(for: .event)
    
    /// Returns the permission type for this kit
    var permissionType: PermissionType {
        return .calendar
    }
    
    /// Requests calendar access permission from the user
    func requestPermission(completion: ( (AuthorizationStatus) -> Void)? = nil) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.status = .notDetermined
                    return
                }
                self.status = granted ? .authorized : .denied
                completion?(self.permissionStatus)
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
            CalendarPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
