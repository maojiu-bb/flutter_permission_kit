//
//  TrackingPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import Foundation
import SwiftUI
import AppTrackingTransparency
import AdSupport

@available(iOS 15.0, *)
class TrackingPermissionKit: ObservableObject, PermissionKitProtocol {
    @Published var status: ATTrackingManager.AuthorizationStatus = ATTrackingManager.trackingAuthorizationStatus
    
    var permissionType: PermissionType {
        return .tracking
    }
    
    func requestPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                self.status = status
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
    
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView {
        return AnyView(
            TrackingPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
