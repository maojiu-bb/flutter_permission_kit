//
//  ContractsPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import Foundation
import SwiftUI
import Contacts

/// Contacts permission kit for managing address book access
/// Handles contacts permission requests using the Contacts framework
@available(iOS 15.0, *)
class ContactsPermissionKit: ObservableObject, PermissionKitProtocol {
    /// Current contacts authorization status from CNContactStore
    @Published var status: CNAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    
    /// Returns the permission type for this kit
    var permissionType: PermissionType {
        return .contacts
    }
    
    /// Requests contacts access permission from the user
    func requestPermission(completion: ( (AuthorizationStatus) -> Void)? = nil) {
        let contactStore = CNContactStore()
        contactStore.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                self.status = CNContactStore.authorizationStatus(for: .contacts)
                completion?(self.permissionStatus)
            }
        }
    }
    
    /// Converts CNContactStore authorization status to common AuthorizationStatus
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .authorized:
            return .granted
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .limited:
            return .limited
        @unknown default:
            // Handle any future unknown authorization status cases
            return .notDetermined
        }
    }
    
    /// Creates a SwiftUI card for contacts permission request
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
            ContactsPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
