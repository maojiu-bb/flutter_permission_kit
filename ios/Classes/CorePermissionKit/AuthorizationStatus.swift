//
//  AuthorizationStatus.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/28.
//

import Foundation

/**
 * AuthorizationStatus
 * 
 * A unified enumeration that represents the authorization status for all permission types
 * across different iOS system frameworks. This enum provides a consistent interface for
 * permission status handling, abstracting away the differences between various iOS
 * permission APIs (AVFoundation, Photos, CoreLocation, etc.).
 * 
 * **Purpose**: 
 * - Standardizes permission status representation across the permission kit system
 * - Simplifies permission status checks and handling in UI components
 * - Provides a bridge between iOS-specific permission states and Flutter layer
 * - Enables consistent permission flow management regardless of permission type
 * 
 * **Architecture Benefits**:
 * - **Consistency**: All permission kits use the same status representation
 * - **Maintainability**: Changes to status handling can be centralized
 * - **Extensibility**: New permission types can easily adopt this standard
 * - **Cross-platform**: Facilitates mapping to Flutter's permission status model
 * 
 * **Usage Example**:
 * ```swift
 * let cameraKit = CameraPermissionKit()
 * switch cameraKit.permissionStatus {
 * case .granted:
 *     // Proceed with camera functionality
 * case .denied:
 *     // Show alternative UI or explanation
 * case .limited:
 *     // Handle limited access scenario
 * case .notDetermined:
 *     // Prompt user for permission
 * }
 * ```
 */
enum AuthorizationStatus {
    /**
     * Permission has been granted with full access
     * 
     * The user has explicitly granted permission for this functionality.
     * The app can freely use the requested system feature without restrictions.
     * 
     * **iOS Framework Mappings**:
     * - AVFoundation: .authorized
     * - Photos: .authorized  
     * - CoreLocation: .authorizedWhenInUse, .authorizedAlways
     * - UserNotifications: .authorized
     * 
     * **UI Behavior**: Show "Allowed" status, disable request button
     * **App Behavior**: Full functionality available
     */
    case granted
    
    /**
     * Permission has been explicitly denied by the user
     * 
     * The user has declined to grant permission, or the permission has been
     * restricted by system policies (e.g., parental controls, enterprise policies).
     * The app cannot access the requested system feature.
     * 
     * **iOS Framework Mappings**:
     * - AVFoundation: .denied, .restricted
     * - Photos: .denied, .restricted
     * - CoreLocation: .denied, .restricted
     * - UserNotifications: .denied
     * 
     * **UI Behavior**: Show "Denied" status with settings redirect option
     * **App Behavior**: Provide alternative functionality or graceful degradation
     */
    case denied
    
    /**
     * Permission has been granted with limited access (iOS 14+)
     * 
     * Available primarily for Photos permission where users can grant access
     * to only selected photos rather than the entire photo library. This status
     * indicates partial access has been granted.
     * 
     * **iOS Framework Mappings**:
     * - Photos: .limited (iOS 14+)
     * - Future frameworks may adopt similar limited access patterns
     * 
     * **UI Behavior**: Show "Limited" status with option to expand access
     * **App Behavior**: Work with available subset of data, offer expansion
     * 
     * **Note**: Not all permission types support limited access. For permissions
     * that don't support this concept, this status should not be used.
     */
    case limited
    
    /**
     * Permission status has not yet been determined by the user
     * 
     * The system permission dialog has not been presented to the user yet,
     * or the user hasn't made a decision. This is the initial state for
     * all permissions before any user interaction.
     * 
     * **iOS Framework Mappings**:
     * - AVFoundation: .notDetermined
     * - Photos: .notDetermined
     * - CoreLocation: .notDetermined
     * - UserNotifications: .notDetermined
     * 
     * **UI Behavior**: Show "Allow" button to trigger permission request
     * **App Behavior**: Present permission request when feature is accessed
     * 
     * **Important**: This is the only status where calling permission request
     * APIs will show the system permission dialog to the user.
     */
    case notDetermined
    
    /**
     * To rawValue
     * 
     * This method is used to convert the authorization status to a raw value.
     * It is used to convert the authorization status to a raw value.
     * 
     * Parameters:
     * - [self]: The authorization status to convert
     * 
     */
    func toRawValue() -> String {
        switch self {
        case .granted: return "granted"
        case .denied: return "denied"
        case .limited: return "limited"
        case .notDetermined: return "notDetermined"
        }
    }
}
