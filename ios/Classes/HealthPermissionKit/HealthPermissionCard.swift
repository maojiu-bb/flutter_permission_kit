//
//  HealthPermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/8.
//

import SwiftUI
import HealthKit

/**
 * HealthPermissionCard
 * 
 * A SwiftUI view component that provides a user interface for requesting health data permissions.
 * This card displays health permission information and handles the permission request flow.
 * It integrates with the CorePermissionCard for consistent UI styling and behavior.
 * 
 * Key Features:
 * - Displays customizable title and description for health permission request
 * - Handles permission request button interactions
 * - Monitors permission status changes and triggers completion callbacks
 * - Provides fallback UI when health permission kit is unavailable
 * - Integrates with the unified permission management system
 * - Handles HealthKit-specific authorization flow
 * 
 * Requirements: iOS 15.0 or later, HealthKit framework
 */
@available(iOS 15.0, *)
struct HealthPermissionCard: View {
    
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
     * If nil, the card will display a default title of "Health Data".
     * This allows customization of the permission request message.
     */
    var title: String?
    
    /**
     * Optional custom description for the permission card
     * 
     * If nil, the card will display a default description "Allow access to your health data".
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
     * Computed property that retrieves the registered health permission kit instance
     * 
     * This property uses the PermissionKitManager to get the health permission kit
     * that was registered during app initialization. Returns nil if the health
     * permission kit hasn't been registered or is unavailable.
     * 
     * Returns: HealthPermissionKit? - The health permission kit instance or nil
     */
    private var healthPermissionKit: HealthPermissionKit? {
        return PermissionKitManager.shared.getKit(for: .health) as? HealthPermissionKit
    }
    
    /**
     * Initializer for HealthPermissionCard
     * 
     * Creates a new health permission card with optional customization parameters.
     * All parameters are optional and have default values.
     * 
     * Parameters:
     * - title: Custom title text (optional, defaults to "Health Data")
     * - description: Custom description text (optional, defaults to standard message)
     * - onPermissionsCompleted: Callback for when permission flow completes (optional)
     */
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    /**
     * The main view body that renders the health permission card UI
     * 
     * This computed property defines the SwiftUI view hierarchy for the permission card.
     * It conditionally renders either the permission card or an error message based on
     * health kit availability and device compatibility.
     * 
     * Returns: SwiftUI View - The complete health permission card interface
     */
    var body: some View {
        Group {
            // Check if HealthKit is available on this device
            if !HKHealthStore.isHealthDataAvailable() {
                /**
                 * Fallback UI when HealthKit is not available on the device
                 * 
                 * This message is displayed when HealthKit is not supported on the current device
                 * (e.g., iPad models that don't support HealthKit).
                 */
                VStack(spacing: 8) {
                    Text("Health Data Not Available")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text("Health data is not available on this device")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            // Check if health permission kit is available
            else if let kit = healthPermissionKit {
                /**
                 * Main permission card component using CorePermissionCard
                 * 
                 * This creates a standardized permission card with health-specific content.
                 * The CorePermissionCard provides consistent styling and behavior across
                 * all permission types while allowing customization of content.
                 * 
                 * Configuration:
                 * - icon: "heart.fill" - SF Symbol icon for health/medical data
                 * - title: Custom title or default "Health Data"
                 * - description: Custom description or default health access message
                 * - permissionKit: The health permission kit instance for status tracking
                 * - Action closure: Triggers health permission request when button is tapped
                 */
                CorePermissionCard<HealthPermissionKit>(
                    icon: "heart.fill",
                    title: title ?? "Health Data",
                    description: description ?? "Allow access to your health data",
                    permissionKit: kit
                ) {
                    // Action executed when permission request button is tapped
                    kit.requestPermission()
                }
                /**
                 * Permission status change observer
                 * 
                 * This modifier listens for changes to the health permission status
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
                 * 
                 * Note: HealthKit permissions are unique because they're granular and users
                 * can approve/deny individual data types, but we treat the overall permission
                 * as determined once the user has interacted with the health permission dialog.
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
                 * Fallback UI when health permission kit is not available
                 * 
                 * This error state is displayed when the health permission kit
                 * hasn't been properly registered or is unavailable for some reason.
                 * It provides clear feedback to developers about the configuration issue.
                 */
                VStack(spacing: 8) {
                    Text("Health Permission Kit Not Available")
                        .font(.headline)
                        .foregroundStyle(.red)
                    
                    Text("Health permission kit has not been properly configured")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
    }
} 