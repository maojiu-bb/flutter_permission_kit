//
//  PhotosPermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/30.
//

import SwiftUI

/// Photos permission request UI component
@available(iOS 15.0, *)
struct PhotosPermissionCard: View {
    
    /// Core permission kit for status coordination
    ///
    /// Reference to the core permission kit to check overall permission
    /// status and coordinate completion callbacks across all permission types.
    private let corePermissionKit = CorePermissionKit.share
    
    /// Custom title for the permission card
    ///
    /// If provided, this title will be displayed instead of the default
    /// "Photo Library" title. Allows for customization based on specific use cases.
    var title: String?
    
    /// Custom description for the permission request
    ///
    /// If provided, this description will be displayed instead of the default
    /// "Allow to access your photos" message. Enables context-specific
    /// explanations of why photo library access is needed.
    var description: String?
    
    /// Completion callback for permission determination
    ///
    /// This callback is invoked when the photos permission status changes
    /// from undetermined to any determined state (granted, denied, limited).
    /// Used to coordinate dismissal of the permission interface.
    var onPermissionsCompleted: (() -> Void)?
    
    /// Registered photos permission kit instance
    ///
    /// This computed property retrieves the registered PhotosPermissionKit
    /// instance from PermissionKitManager, ensuring we use the same instance
    /// that's used throughout the permission system for state consistency.
    ///
    /// Using the registered instance prevents state synchronization issues
    /// that could occur if each UI component created its own kit instance.
    private var photosPermissionKit: PhotosPermissionKit? {
        return PermissionKitManager.shared.getKit(for: .photos) as? PhotosPermissionKit
    }
    
    /// Custom initializer to accept configuration parameters
    ///
    /// - Parameters:
    ///   - title: Optional custom title for the permission card
    ///   - description: Optional custom description for the permission request
    ///   - onPermissionsCompleted: Optional callback for permission completion
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    /// SwiftUI view body
    ///
    /// Creates the visual representation of the photos permission card using
    /// the CorePermissionCard as the base component to maintain visual
    /// consistency across all permission types.
    ///
    /// The view automatically updates its appearance based on the current
    /// photos permission status and handles user interactions.
    ///
    /// **State Management**: This view uses onReceive to monitor permission
    /// status changes from the registered kit instance, ensuring proper
    /// state synchronization and UI updates.
    var body: some View {
        Group {
            if let kit = photosPermissionKit {
                CorePermissionCard<PhotosPermissionKit>(
                    icon: "photo",                                      // SF Symbol for photos
                    title: title ?? "Photo Library",                   // Custom or default title
                    description: description ?? "Allow to access your photos",  // Custom or default description
                    permissionKit: kit                                  // Pass the entire kit for observation
                ) {
                    // Handle permission request when card is tapped
                    kit.requestPermission()
                }
                .onReceive(kit.$status) { newStatus in
                    // Monitor photos permission status changes using the registered kit
                    if newStatus != .notDetermined {
                        // Permission has been determined (granted, denied, limited)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            let statusMap = corePermissionKit.checkPermissionsStatus()
                            let hasUndetermined = statusMap.values.contains(.notDetermined)
                            
                            if !hasUndetermined {
                                // All permissions have been determined, trigger completion
                                onPermissionsCompleted?()
                            }
                        }
                    }
                }
            } else {
                // Fallback view if photos permission kit is not registered
                // This should not happen in normal operation but provides graceful degradation
                Text("Photos permission kit not available")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
}
