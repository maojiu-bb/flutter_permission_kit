//
//  MotionPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/8.
//

import Foundation
import CoreMotion
import SwiftUI

/**
 * MotionPermissionKit
 * 
 * A specialized permission management class for handling motion and fitness data access permissions in iOS.
 * This class implements the PermissionKitProtocol to provide a unified interface for motion permission handling.
 * It manages the motion activity authorization status and provides methods to request permissions and create UI components.
 * 
 * Key Features:
 * - Tracks real-time motion activity permission status using CoreMotion
 * - Provides methods to request motion and fitness data access permissions
 * - Creates UI components for permission request flows
 * - Maps system authorization status to unified permission states
 * - Handles motion activity manager initialization and permission requests
 * 
 * Requirements: iOS 15.0 or later
 */
@available(iOS 15.0, *)
class MotionPermissionKit: ObservableObject, PermissionKitProtocol {
    
    /**
     * Published property that tracks the current motion activity authorization status
     * 
     * This property is automatically updated when permission status changes and will
     * trigger UI updates in SwiftUI views that observe this object.
     * Uses CMMotionActivityManager to get the current authorization status for motion data.
     */
    @Published var status: CMAuthorizationStatus = CMMotionActivityManager.authorizationStatus()
    
    /// Motion activity manager instance for handling motion permission requests
    ///
    /// This manager is used to request authorization for motion and fitness data access.
    /// It's lazily initialized to avoid unnecessary resource allocation if motion
    /// permissions are not actually needed.
    private lazy var motionActivityManager = CMMotionActivityManager()
    
    /**
     * Computed property that returns the permission type identifier
     * 
     * This property is required by the PermissionKitProtocol and identifies
     * this kit as handling motion permissions specifically.
     * 
     * Returns: PermissionType.motion - indicates this kit handles motion permissions
     */
    var permissionType: PermissionType {
        return .motion
    }
    
    /**
     * Requests motion and fitness data access permission from the user
     * 
     * This method triggers the system permission dialog for motion activity access.
     * It uses CMMotionActivityManager to prompt the user for permission to access
     * motion and fitness data. After the user responds, it updates the status property
     * on the main thread to ensure UI updates happen correctly.
     * 
     * Flow:
     * 1. Calls CMMotionActivityManager.queryActivityStarting to trigger permission dialog
     * 2. Receives callback with activities data or error
     * 3. Updates the status property on main thread
     * 4. SwiftUI views observing this object will automatically update
     * 
     * Note: The queryActivityStarting method is used to trigger the permission dialog
     * rather than a dedicated permission request method, as this is the standard
     * approach for motion activity permissions in iOS.
     */
    func requestPermission() {
        // Create a date range for the query (using a small recent range to minimize data processing)
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .minute, value: -1, to: endDate) ?? endDate
        
        // Query motion activity to trigger permission dialog
        motionActivityManager.queryActivityStarting(from: startDate, to: endDate, to: OperationQueue.main) { [weak self] (activities, error) in
            DispatchQueue.main.async {
                // Update the status after permission request completes
                // This ensures UI updates happen on the main thread
                self?.status = CMMotionActivityManager.authorizationStatus()
            }
        }
    }
    
    /**
     * Computed property that maps CMAuthorizationStatus to unified AuthorizationStatus
     * 
     * This property converts the system-specific CMAuthorizationStatus enum values
     * to the unified AuthorizationStatus enum used throughout the permission kit.
     * This abstraction allows consistent permission handling across different permission types.
     * 
     * Mapping:
     * - .authorized → .granted: User has granted motion data access permission
     * - .denied → .denied: User has explicitly denied motion data access permission
     * - .restricted → .denied: Motion data access is restricted (e.g., parental controls)
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
     * Creates a SwiftUI view component for motion permission requests
     * 
     * This method generates a motion-specific permission card UI component that can be
     * embedded in permission request flows. The card includes customizable title and
     * description text, and calls the completion handler when permission flow is complete.
     * 
     * Parameters:
     * - title: Optional custom title for the permission card (defaults to "Motion & Fitness" if nil)
     * - description: Optional custom description text (defaults to standard message if nil)
     * - onPermissionsCompleted: Callback function executed when permission request is complete
     * 
     * Returns: AnyView - Type-erased SwiftUI view containing the motion permission card
     * 
     * Usage:
     * ```swift
     * let permissionCard = motionKit.createPermissionCard(
     *     title: "Motion & Fitness Access",
     *     description: "This app needs motion access to track your daily activities and fitness goals"
     * ) {
     *     print("Motion permission request completed")
     * }
     * ```
     */
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView {
        return AnyView(
            MotionPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
} 