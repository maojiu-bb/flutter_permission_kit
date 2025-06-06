//
//  MusicPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/7.
//

import Foundation
import SwiftUI
import Intents

/// Siri permission kit for managing Apple Music access
@available(iOS 15.0, *)
class SiriPermissionKit: ObservableObject, PermissionKitProtocol {
    @Published var status: INSiriAuthorizationStatus = INPreferences.siriAuthorizationStatus()
    
    /// Returns the permission type for this kit
    var permissionType: PermissionType {
        return .siri
    }
    
    func requestPermission() {
        INPreferences.requestSiriAuthorization { newStatus in
            DispatchQueue.main.async {
                self.status = newStatus
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
            SiriPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
