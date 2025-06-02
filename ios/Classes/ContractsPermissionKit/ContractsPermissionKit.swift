//
//  ContractsPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//


import Foundation
import SwiftUI
import Contacts

@available(iOS 15.0, *)
class ContractsPermissionKit: ObservableObject, PermissionKitProtocol {
    @Published var status: CNAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    
    var permissionType: PermissionType {
        return .contracts
    }
    
    func requestPermission() {
        let contactStore = CNContactStore()
        contactStore.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                self.status = CNContactStore.authorizationStatus(for: .contacts)
            }
        }
    }
    
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .authorized:
            return .granted
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            // Handle any future unknown authorization status cases
            return .notDetermined
        }
    }
    
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView {
        return AnyView(
            ContractsPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
