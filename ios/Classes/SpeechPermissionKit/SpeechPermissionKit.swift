//
//  SpeechPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import Foundation
import SwiftUI
import Speech

@available(iOS 15.0, *)
class SpeechPermissionKit: ObservableObject, PermissionKitProtocol {
    @Published var status: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    
    var permissionType: PermissionType {
        return .speech
    }
    
    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { granted in
            DispatchQueue.main.async {
                self.status = granted
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
            SpeechPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
