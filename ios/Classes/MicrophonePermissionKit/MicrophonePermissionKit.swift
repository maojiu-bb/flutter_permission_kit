//
//  MicrophonePermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import Foundation
import SwiftUI
import AVFoundation

/// Microphone permission kit for managing audio recording access
/// Handles microphone permission requests and status tracking using AVFoundation
@available(iOS 15.0, *)
class MicrophonePermissionKit: ObservableObject, PermissionKitProtocol {
    /// Current microphone authorization status from AVFoundation
    @Published var status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    
    /// Returns the permission type for this kit
    var permissionType: PermissionType {
        return .microphone
    }
    
    /// Requests microphone access permission from the user
    func requestPermission(completion: ((AuthorizationStatus) -> Void)? = nil) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                self.status = AVCaptureDevice.authorizationStatus(for: .audio)
                completion?(self.permissionStatus)
            }
        }
    }
    
    /// Converts AVFoundation authorization status to common AuthorizationStatus
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
    
    /// Creates a SwiftUI card for microphone permission request
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
            MicrophonePermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
