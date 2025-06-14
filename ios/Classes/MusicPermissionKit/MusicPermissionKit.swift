//
//  MusicPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/6.
//

import Foundation
import SwiftUI
import StoreKit

/// Apple Music permission kit for managing Apple Music access
/// Handles music permission requests using the StoreKit framework
@available(iOS 15.0, *)
class MusicPermissionKit: ObservableObject, PermissionKitProtocol {
    /// Current Apple Music authorization status from SKCloudServiceController
    @Published var status: SKCloudServiceAuthorizationStatus = SKCloudServiceController.authorizationStatus()
    
    /// Returns the permission type for this kit
    var permissionType: PermissionType {
        return .music
    }
    
    /// Requests Apple Music access permission from the user
    func requestPermission(completion: ((AuthorizationStatus) -> Void)? = nil) {
        SKCloudServiceController.requestAuthorization { newStatus in
            DispatchQueue.main.async {
                self.status = newStatus
                completion?(self.permissionStatus)
            }
        }
    }
    
    /// Converts SKCloudServiceAuthorizationStatus to common AuthorizationStatus
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .authorized:
            return .granted
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
    }
    
    /// Creates a SwiftUI card for music permission request
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
            MusicPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
