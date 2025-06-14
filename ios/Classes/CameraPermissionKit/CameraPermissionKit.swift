//
//  CameraPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Foundation
import AVFoundation
import SwiftUI

/**
 * CameraPermissionKit
 *
 * A specialized permission management class for handling camera access permissions in iOS.
 * This class implements the PermissionKitProtocol to provide a unified interface for camera permission handling.
 * It manages the camera authorization status and provides methods to request permissions and create UI components.
 *
 * Key Features:
 * - Tracks real-time camera permission status using AVFoundation
 * - Provides methods to request camera access permissions
 * - Creates UI components for permission request flows
 * - Maps system authorization status to unified permission states
 *
 * Requirements: iOS 15.0 or later
 */
@available(iOS 15.0, *)
class CameraPermissionKit: ObservableObject, PermissionKitProtocol {
    
    /**
     * Published property that tracks the current camera authorization status
     *
     * This property is automatically updated when permission status changes and will
     * trigger UI updates in SwiftUI views that observe this object.
     * Uses AVCaptureDevice to get the current authorization status for video capture.
     */
    @Published var status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    
    /**
     * Computed property that returns the permission type identifier
     *
     * This property is required by the PermissionKitProtocol and identifies
     * this kit as handling camera permissions specifically.
     *
     * Returns: PermissionType.camera - indicates this kit handles camera permissions
     */
    var permissionType: PermissionType {
        return .camera
    }
    
    /**
     * Requests camera access permission from the user
     *
     * This method triggers the system permission dialog for camera access.
     * It uses AVCaptureDevice.requestAccess to prompt the user for permission.
     * After the user responds, it updates the status property on the main thread
     * to ensure UI updates happen correctly.
     *
     * Flow:
     * 1. Calls AVCaptureDevice.requestAccess for video media type
     * 2. Receives callback with granted/denied result
     * 3. Updates the status property on main thread
     * 4. SwiftUI views observing this object will automatically update
     */
    func requestPermission(completion: ( (AuthorizationStatus) -> Void)? = nil) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                // Update the status after permission request completes
                // This ensures UI updates happen on the main thread
                self.status = AVCaptureDevice.authorizationStatus(for: .video)
                completion?(self.permissionStatus)
            }
        }
    }
    
    /**
     * Computed property that maps AVAuthorizationStatus to unified AuthorizationStatus
     *
     * This property converts the system-specific AVAuthorizationStatus enum values
     * to the unified AuthorizationStatus enum used throughout the permission kit.
     * This abstraction allows consistent permission handling across different permission types.
     *
     * Mapping:
     * - .authorized → .granted: User has granted camera permission
     * - .denied → .denied: User has explicitly denied camera permission
     * - .restricted → .denied: Camera access is restricted (e.g., parental controls)
     * - .notDetermined → .notDetermined: User hasn't been asked for permission yet
     * - @unknown default → .notDetermined: Future unknown cases default to not determined
     *
     * Returns: AuthorizationStatus - unified permission status enum value
     */
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
    
    /**
     * Creates a SwiftUI view component for camera permission requests
     *
     * This method generates a camera-specific permission card UI component that can be
     * embedded in permission request flows. The card includes customizable title and
     * description text, and calls the completion handler when permission flow is complete.
     *
     * Parameters:
     * - title: Optional custom title for the permission card (defaults to "Camera" if nil)
     * - description: Optional custom description text (defaults to standard message if nil)
     * - onPermissionsCompleted: Callback function executed when permission request is complete
     *
     * Returns: AnyView - Type-erased SwiftUI view containing the camera permission card
     *
     * Usage:
     * ```swift
     * let permissionCard = cameraKit.createPermissionCard(
     *     title: "Camera Access",
     *     description: "This app needs camera access to take photos"
     * ) {
     *     print("Camera permission request completed")
     * }
     * ```
     */
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView {
        return AnyView(
            CameraPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
