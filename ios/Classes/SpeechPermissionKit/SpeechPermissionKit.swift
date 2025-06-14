//
//  SpeechPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import Foundation
import SwiftUI
import Speech

/// Speech recognition permission kit for managing voice-to-text access
/// Handles speech recognition permission requests using Apple's Speech framework
@available(iOS 15.0, *)
class SpeechPermissionKit: ObservableObject, PermissionKitProtocol {
    /// Current speech recognition authorization status
    @Published var status: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    
    /// Returns the permission type for this kit
    var permissionType: PermissionType {
        return .speech
    }
    
    /// Initializes the kit and refreshes current speech permission status
    init() {
        self.refreshSpeechPermission()
    }
    
    /// Updates the current speech recognition permission status
    func refreshSpeechPermission() {
        self.status = SFSpeechRecognizer.authorizationStatus()
    }
    
    /// Requests speech recognition access permission from the user
    func requestPermission(completion: ((AuthorizationStatus) -> Void)? = nil) {
        SFSpeechRecognizer.requestAuthorization { granted in
            DispatchQueue.main.async {
                self.refreshSpeechPermission()
                completion?(self.permissionStatus)
            }
        }
    }
    
    /// Converts Speech framework authorization status to common AuthorizationStatus
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
    
    /// Creates a SwiftUI card for speech recognition permission request
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
            SpeechPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
