//
//  MotionPermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/8.
//

import SwiftUI

/**
 * MotionPermissionCard
 * 
 * A SwiftUI view component that provides a user interface for requesting motion and fitness data permissions.
 * This card displays motion permission information and handles the permission request flow.
 * It integrates with the CorePermissionCard for consistent UI styling and behavior.
 * 
 * Key Features:
 * - Displays customizable title and description for motion permission request
 * - Handles permission request button interactions
 * - Monitors permission status changes and triggers completion callbacks
 * - Provides fallback UI when motion permission kit is unavailable
 * - Integrates with the unified permission management system
 * 
 * Requirements: iOS 15.0 or later
 */
@available(iOS 15.0, *)
struct MotionPermissionCard: View {
    
    /**
     * Shared instance of CorePermissionKit for managing overall permission state
     * 
     * This provides access to the core permission management functionality,
     * including checking the status of all registered permission types.
     */
    private let corePermissionKit = CorePermissionKit.share
    
    /**
     * Optional custom title for the permission card
     * 
     * If nil, the card will display a default title of "Motion & Fitness".
     * This allows customization of the permission request message.
     */
    var title: String?
    
    /**
     * Optional custom description for the permission card
     * 
     * If nil, the card will display a default description "Allow to access your motion and fitness data".
     * This allows customization of the permission explanation text.
     */
    var description: String?
    
    /**
     * Optional callback function executed when permission flow is completed
     * 
     * This closure is called when all permissions have been determined (granted or denied)
     * and there are no more undetermined permission states remaining.
     */
    var onPermissionsCompleted: (() -> Void)?
    
    /**
     * Computed property that retrieves the registered motion permission kit instance
     * 
     * This property uses the PermissionKitManager to get the motion permission kit
     * that was registered during app initialization. Returns nil if the motion
     * permission kit hasn't been registered or is unavailable.
     * 
     * Returns: MotionPermissionKit? - The motion permission kit instance or nil
     */
    private var motionPermissionKit: MotionPermissionKit? {
        return PermissionKitManager.shared.getKit(for: .motion) as? MotionPermissionKit
    }
    
    /**
     * Initializer for MotionPermissionCard
     * 
     * Creates a new motion permission card with optional customization parameters.
     * All parameters are optional and have default values.
     * 
     * Parameters:
     * - title: Custom title text (optional, defaults to "Motion & Fitness")
     * - description: Custom description text (optional, defaults to standard message)
     * - onPermissionsCompleted: Callback for when permission flow completes (optional)
     */
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    /**
     * The main view body that renders the motion permission card UI
     * 
     * This computed property defines the SwiftUI view hierarchy for the permission card.
     * It conditionally renders either the permission card or an error message based on
     * motion kit availability.
     * 
     * Returns: SwiftUI View - The complete motion permission card interface
     */
    var body: some View {
        Group {
            // Check if motion permission kit is available
            if let kit = motionPermissionKit {
                /**
                 * Main permission card component using CorePermissionCard
                 * 
                 * This creates a standardized permission card with motion-specific content.
                 * The CorePermissionCard provides consistent styling and behavior across
                 * all permission types while allowing customization of content.
                 * 
                 * Configuration:
                 * - icon: "figure.walk" - SF Symbol icon for motion and fitness
                 * - title: Custom title or default "Motion & Fitness"
                 * - description: Custom description or default motion access message
                 * - permissionKit: The motion permission kit instance for status tracking
                 * - Action closure: Triggers motion permission request when button is tapped
                 */
                CorePermissionCard<MotionPermissionKit>(
                    icon: "figure.walk",
                    title: title ?? "Motion & Fitness",
                    description: description ?? "Allow to access your motion and fitness data",
                    permissionKit: kit
                ) {
                    // Action executed when permission request button is tapped
                    kit.requestPermission()
                }
                /**
                 * Permission status change observer
                 * 
                 * This modifier listens for changes to the motion permission status
                 * and triggers the completion callback when appropriate conditions are met.
                 * 
                 * Logic Flow:
                 * 1. Monitors kit.$status publisher for permission status changes
                 * 2. When status changes from .notDetermined, waits 200ms for system to settle
                 * 3. Checks if any permissions are still undetermined across all kits
                 * 4. Calls completion callback if all permissions have been determined
                 * 
                 * The 200ms delay ensures that multiple permission dialogs don't interfere
                 * with each other and allows the system to fully process the permission change.
                 */
                .onReceive(kit.$status) { newStatus in
                    // Only process status changes after user has interacted with permission dialog
                    if newStatus != .notDetermined {
                        // Add slight delay to ensure system has fully processed the permission change
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            // Check the current status of all registered permission types
                            let statusMap = corePermissionKit.checkPermissionsStatus()
                            
                            // Determine if any permissions are still undetermined
                            let hasUndetermined = statusMap.values.contains(.notDetermined)
                            
                            // If all permissions have been determined, call completion callback
                            if !hasUndetermined {
                                onPermissionsCompleted?()
                            }
                        }
                    }
                }
            } else {
                /**
                 * Fallback UI when motion permission kit is not available
                 * 
                 * This error state is displayed when the motion permission kit
                 * hasn't been properly registered or is unavailable for some reason.
                 * It provides clear feedback to developers about the configuration issue.
                 */
                Text("Motion permission kit not available")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
} 