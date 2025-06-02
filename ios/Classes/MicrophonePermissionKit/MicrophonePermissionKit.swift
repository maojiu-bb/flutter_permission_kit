//
//  MicrophonePermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import Foundation
import SwiftUI
import AVFoundation

@available(iOS 15.0, *)
class MicrophonePermissionKit: ObservableObject, PermissionKitProtocol {
    @Published var status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    
    var permissionType: PermissionType {
        return .microphone
    }
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                self.status = AVCaptureDevice.authorizationStatus(for: .audio)
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
            MicrophonePermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
