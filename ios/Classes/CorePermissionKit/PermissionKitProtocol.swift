//
//  PermissionKitProtocol.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Foundation
import SwiftUI

/// Protocol that defines the common interface for all permission kits
///
/// This protocol ensures consistency across different permission implementations
/// and provides a standardized way to handle various iOS permissions.
/// Each specific permission kit (Photos, Camera, Location, etc.) should conform
/// to this protocol to maintain architectural consistency.
///
/// The protocol defines the essential methods and properties required for:
/// - Permission status checking
/// - Permission request handling
/// - UI component generation
/// - Integration with the core permission system
///
/// Benefits of this protocol approach:
/// 1. **Consistency**: All permission kits follow the same interface
/// 2. **Extensibility**: Easy to add new permission types
/// 3. **Maintainability**: Centralized contract for permission handling
/// 4. **Testability**: Mockable interface for unit testing
///
/// Example implementation:
/// ```swift
/// @available(iOS 15.0, *)
/// class CameraPermissionKit: PermissionKitProtocol {
///     var permissionType: PermissionType { .camera }
///     var permissionStatus: AuthorizationStatus { /* implementation */ }
///     
///     func requestPermission() { /* implementation */ }
///     func createPermissionCard(/* parameters */) -> AnyView { /* implementation */ }
/// }
/// ```
@available(iOS 15.0, *)
protocol PermissionKitProtocol: ObservableObject {
    
    /// The type of permission this kit handles
    ///
    /// This property identifies which specific permission type this kit manages.
    /// It's used by the core system to route permission requests and status
    /// checks to the appropriate kit implementation.
    ///
    /// Example:
    /// ```swift
    /// var permissionType: PermissionType { .camera }
    /// ```
    var permissionType: PermissionType { get }
    
    /// Current authorization status for this permission
    ///
    /// This property provides a unified way to check the current permission
    /// status across all permission types. It should be updated whenever
    /// the underlying system permission status changes.
    ///
    /// The status should map the platform-specific permission states to
    /// our unified AuthorizationStatus enum:
    /// - .notDetermined: User hasn't been asked yet
    /// - .granted: User has granted full access
    /// - .denied: User has denied access
    /// - .limited: User has granted limited access (iOS 14+ photos)
    ///
    /// Example:
    /// ```swift
    /// var permissionStatus: AuthorizationStatus {
    ///     switch AVCaptureDevice.authorizationStatus(for: .video) {
    ///     case .authorized: return .granted
    ///     case .denied, .restricted: return .denied
    ///     case .notDetermined: return .notDetermined
    ///     @unknown default: return .notDetermined
    ///     }
    /// }
    /// ```
    var permissionStatus: AuthorizationStatus { get }
    
    /// Requests permission from the user
    ///
    /// This method should trigger the system permission dialog for this
    /// specific permission type. It should handle the asynchronous nature
    /// of permission requests and update the permissionStatus property
    /// when the user responds.
    ///
    /// Implementation should:
    /// 1. Call the appropriate iOS permission request API
    /// 2. Handle the response asynchronously
    /// 3. Update the permissionStatus property on the main thread
    /// 4. Be safe to call multiple times
    ///
    /// Example:
    /// ```swift
    /// func requestPermission() {
    ///     AVCaptureDevice.requestAccess(for: .video) { granted in
    ///         DispatchQueue.main.async {
    ///             // Update status based on result
    ///         }
    ///     }
    /// }
    /// ```
    func requestPermission(completion: ((AuthorizationStatus) -> Void)?)
    
    /// Creates a SwiftUI view component for this permission
    ///
    /// This method generates the UI component that will be displayed in the
    /// permission request screen. It should use the CorePermissionCard as
    /// the base component to maintain visual consistency.
    ///
    /// The generated view should:
    /// - Display appropriate icon, title, and description
    /// - Handle permission request when tapped
    /// - Update UI based on permission status changes
    /// - Call the completion handler when permission is determined
    ///
    /// - Parameters:
    ///   - title: Optional custom title for the permission card
    ///   - description: Optional custom description for the permission card
    ///   - onPermissionsCompleted: Callback invoked when permission is determined
    ///
    /// - Returns: A SwiftUI view wrapped in AnyView for type erasure
    ///
    /// Example:
    /// ```swift
    /// func createPermissionCard(
    ///     title: String?,
    ///     description: String?,
    ///     onPermissionsCompleted: @escaping () -> Void
    /// ) -> AnyView {
    ///     AnyView(
    ///         CameraPermissionCard(
    ///             title: title,
    ///             description: description,
    ///             onPermissionsCompleted: onPermissionsCompleted
    ///         )
    ///     )
    /// }
    /// ```
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView
} 
