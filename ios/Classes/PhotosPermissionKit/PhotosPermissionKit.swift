//
//  PhotosPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/28.
//

import Foundation
import Photos
import SwiftUI

/**
 * PhotosPermissionKit
 * 
 * A specialized permission management class for handling photo library access permissions in iOS.
 * This class implements the PermissionKitProtocol to provide a unified interface for photo library
 * permission handling while supporting iOS 14+ features like limited photo access.
 * 
 * **Key Features**:
 * - **Full Photo Library Access**: Request complete access to user's photo library
 * - **Limited Access Support**: Handle iOS 14+ limited photo selection feature
 * - **Read/Write Permissions**: Request both read and write access for comprehensive functionality
 * - **Real-time Status Tracking**: Monitor permission changes using PHPhotoLibrary notifications
 * - **UI Component Generation**: Create standardized permission request cards
 * 
 * **iOS 14+ Limited Access**:
 * Starting with iOS 14, users can grant limited access to only selected photos rather than
 * their entire photo library. This kit properly handles both full and limited access scenarios.
 * 
 * **Photo Library Access Levels**:
 * - **Full Access (.authorized)**: Complete access to all photos and albums
 * - **Limited Access (.limited)**: Access only to user-selected photos
 * - **No Access (.denied/.restricted)**: No access to photo library
 * - **Undetermined (.notDetermined)**: User hasn't been asked for permission yet
 * 
 * **Integration Requirements**:
 * - Info.plist: NSPhotoLibraryUsageDescription key required
 * - iOS Version: Photos framework features vary by iOS version
 * - Privacy: Handle user data responsibly and transparently
 * 
 * **Example Usage**:
 * ```swift
 * let photosKit = PhotosPermissionKit()
 * 
 * // Check current status
 * switch photosKit.permissionStatus {
 * case .granted: // Use full photo library access
 * case .limited: // Work with selected photos
 * case .denied: // Show alternative UI
 * case .notDetermined: // Request permission
 * }
 * 
 * // Request permission
 * photosKit.requestPermission()
 * ```
 * 
 * Requirements: iOS 15.0 or later
 */
@available(iOS 15.0, *)
class PhotosPermissionKit: ObservableObject, PermissionKitProtocol {
    
    /**
     * Published property tracking the current photo library authorization status
     * 
     * This property automatically reflects the current authorization status for photo library
     * access and triggers UI updates when the status changes. It uses PHPhotoLibrary's
     * readWrite access level to request comprehensive permissions.
     * 
     * **Access Level**: Uses .readWrite to request both read and write permissions,
     * enabling full photo library functionality including saving photos.
     * 
     * **Reactive Updates**: The @Published wrapper ensures that any SwiftUI views
     * observing this PhotosPermissionKit instance will automatically update when
     * the permission status changes.
     * 
     * **Initial Value**: Set to current authorization status at initialization time
     */
    @Published var status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    /**
     * Computed property identifying this kit's permission type
     * 
     * This property is required by the PermissionKitProtocol and identifies this kit
     * as handling photo library permissions specifically. Used by the permission
     * management system for routing and identification.
     * 
     * Returns: PermissionType.photos - indicates this kit manages photo library permissions
     */
    var permissionType: PermissionType {
        return .photos
    }
    
    /**
     * Requests photo library access permission from the user
     * 
     * This method triggers the system permission dialog for photo library access.
     * It requests .readWrite permission level to enable comprehensive photo library
     * functionality including reading existing photos and saving new ones.
     * 
     * **Permission Flow**:
     * 1. Calls PHPhotoLibrary.requestAuthorization(for: .readWrite)
     * 2. System presents permission dialog to user
     * 3. User grants full access, limited access, or denies permission
     * 4. Callback executes with new authorization status
     * 5. Status property is updated on main thread for UI synchronization
     * 
     * **iOS 14+ Behavior**: On iOS 14 and later, users can choose between:
     * - "Select Photos": Grants limited access to chosen photos only
     * - "Allow Access to All Photos": Grants full photo library access
     * - "Don't Allow": Denies access completely
     * 
     * **Thread Safety**: Updates the status property on the main thread to ensure
     * proper UI updates and SwiftUI state synchronization.
     */
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
            DispatchQueue.main.async {
                // Update status on main thread for UI consistency
                self.status = newStatus
            }
        }
    }
    
    /**
     * Computed property mapping PHAuthorizationStatus to unified AuthorizationStatus
     * 
     * This property converts the Photos framework's specific authorization status enum
     * to the unified AuthorizationStatus used throughout the permission kit system.
     * This abstraction enables consistent permission handling across different types.
     * 
     * **Status Mapping**:
     * - `.authorized` → `.granted`: Full access to photo library granted
     * - `.denied` → `.denied`: User explicitly denied photo library access
     * - `.restricted` → `.denied`: Access restricted by system policies (parental controls, etc.)
     * - `.limited` → `.limited`: Limited access to selected photos (iOS 14+)
     * - `.notDetermined` → `.notDetermined`: User hasn't been asked for permission
     * - `@unknown default` → `.notDetermined`: Handle future unknown status values safely
     * 
     * **Limited Access Handling**: Unlike other permission types, photo library
     * permissions support a "limited" state where users grant access to only
     * selected photos. This is unique to the Photos framework.
     * 
     * Returns: AuthorizationStatus - unified permission status for consistent handling
     */
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .authorized:
            return .granted
        case .denied, .restricted:
            return .denied
        case .limited:
            return .limited
        case .notDetermined:
            return .notDetermined
        @unknown default:
            // Handle future unknown authorization status values safely
            return .notDetermined
        }
    }
    
    /**
     * Creates a SwiftUI view component for photo library permission requests
     * 
     * This method generates a photo library-specific permission card UI component that
     * can be embedded in permission request flows. The card handles the unique aspects
     * of photo permissions including limited access scenarios.
     * 
     * **Card Features**:
     * - Photo-specific icon and default messaging
     * - Handles limited access status display
     * - Integrates with permission completion flow
     * - Supports custom title and description override
     * 
     * - Parameters:
     *   - title: Optional custom title (defaults to "Photo Library" if nil)
     *   - description: Optional custom description (defaults to standard message if nil)
     *   - onPermissionsCompleted: Callback executed when permission request flow completes
     * 
     * - Returns: AnyView - Type-erased SwiftUI view containing the photos permission card
     * 
     * **Limited Access Consideration**: The generated card properly handles the limited
     * access scenario, showing appropriate status and allowing users to modify their
     * photo selection if needed.
     * 
     * **Usage Example**:
     * ```swift
     * let permissionCard = photosKit.createPermissionCard(
     *     title: "Photo Library Access",
     *     description: "Select and share your favorite photos"
     * ) {
     *     print("Photos permission request completed")
     * }
     * ```
     */
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView {
        return AnyView(
            PhotosPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
