//
//  CorePermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Flutter
import Foundation
import UIKit
import SwiftUI

/**
 * CorePermissionKit
 *
 * The central orchestrator for the Flutter Permission Kit plugin's iOS implementation.
 * This singleton class manages the complete permission request lifecycle from Flutter
 * layer communication to native iOS permission handling and UI presentation.
 *
 * **Architecture Role**:
 * - **Flutter Bridge**: Handles method channel communication with Flutter layer
 * - **Configuration Manager**: Parses and manages permission request configuration
 * - **UI Coordinator**: Orchestrates permission request UI presentation and dismissal
 * - **Kit Registry**: Manages on-demand registration and initialization of specific permission kits
 * - **State Manager**: Tracks permission request state and completion status
 *
 * **Key Responsibilities**:
 * - Parse configuration data from Flutter layer
 * - Register only required permission kits based on configuration (on-demand approach)
 * - Present permission request UI with appropriate display style
 * - Coordinate between multiple permission requests
 * - Handle permission completion and UI dismissal
 * - Provide permission status checking functionality
 *
 * **On-Demand Registration Architecture** (New in v2.0):
 * Previous versions registered all available permission kits during initialization, regardless
 * of whether they would be used. The new on-demand approach offers several benefits:
 * 
 * **Benefits**:
 * - **Memory Efficiency**: Only creates permission kit instances that will actually be used
 * - **Faster Startup**: Reduces initialization time by avoiding unnecessary object creation
 * - **Configuration-Driven**: Adapts to actual usage requirements automatically
 * - **Resource Optimization**: Prevents instantiation of unused permission handlers
 * - **Scalability**: Better performance as more permission types are added to the system
 * 
 * **How On-Demand Registration Works**:
 * 1. Flutter layer sends configuration specifying required permission types
 * 2. CorePermissionKit parses configuration and identifies required permission types
 * 3. Only the permission kits for requested types are instantiated and registered
 * 4. Subsequent permission checks and UI generation use only the registered kits
 * 5. Multiple configuration calls reuse already-registered kits (avoid duplicate registration)
 * 
 * **Example**: If your app only requests camera and photos permissions, only CameraPermissionKit
 * and PhotosPermissionKit will be created. LocationPermissionKit, MicrophonePermissionKit, etc.
 * will not be instantiated at all, saving memory and initialization time.
 *
 * **Permission Request Flow**:
 * 1. Flutter layer sends configuration via method channel
 * 2. CorePermissionKit parses configuration and registers required permission kits
 * 3. If permissions already granted, return success immediately
 * 4. Otherwise, present permission request UI using registered kits
 * 5. User interacts with permission cards
 * 6. Monitor permission status changes across all requested types
 * 7. Dismiss UI when all permissions are determined
 * 8. Return completion status to Flutter layer
 *
 * **UI Presentation Modes**:
 * - **Modal**: Custom SwiftUI interface with full control over design
 * - **Alert**: Native iOS alert style for minimal, system-consistent experience
 *
 * **Backward Compatibility**:
 * The legacy `registerPermissionKits()` method is still available for cases where you need
 * all permission kits registered upfront, but it's no longer called automatically.
 *
 * Requirements: iOS 15.0 or later for SwiftUI features and protocol constraints
 */
@available(iOS 15.0, *)
class CorePermissionKit {
    
    /**
     * Shared singleton instance providing global access to permission management
     *
     * This singleton ensures consistent permission state management across the entire
     * app and provides a single point of access for permission-related operations.
     * All Flutter method channel calls and permission operations route through this instance.
     */
    static let share = CorePermissionKit()
    
    /**
     * Current configuration for the permission request flow
     *
     * Stores the parsed configuration data received from the Flutter layer,
     * including permission types to request, display settings, and text content.
     * This configuration drives the entire permission request UI and behavior.
     *
     * **Lifecycle**: Set during initPermissionKit() and cleared after completion
     * **Usage**: Referenced throughout the permission request flow for UI generation
     */
    private var config: FlutterPermissionKitConfig?
    
    /**
     * Reference to the currently presented permission interface
     *
     * Maintains a reference to the SwiftUI hosting controller that presents the
     * permission request interface. This enables proper dismissal and lifecycle
     * management of the permission UI.
     *
     * **Lifecycle**: Created during UI presentation, cleared after dismissal
     * **Type**: UIHostingController wrapping CorePermissionView with generic content
     */
    private var hostingController: UIHostingController<CorePermissionView<AnyView>>?
    
    /**
     * Reference to the view controller that presented the permission interface
     *
     * Stores the view controller from which the permission interface was presented.
     * This ensures proper presentation hierarchy and enables correct dismissal
     * back to the original presenting controller.
     *
     * **Purpose**: Maintains presentation context for proper UI stack management
     * **Usage**: Used during dismissal to return to the correct view controller
     */
    private var presentingViewController: UIViewController?
    
    /**
     * Private initializer enforcing singleton pattern
     *
     * Initializes the CorePermissionKit without registering permission kits upfront.
     * Permission kits will now be registered on-demand based on configuration requirements.
     * Private access prevents external instantiation, ensuring a single source of
     * truth for permission management throughout the app.
     */
    private init() {
        // Removed automatic registration - kits will be registered on-demand
        // registerPermissionKits()
    }
    
    /**
     * Registers permission kits based on the provided configuration
     *
     * This method dynamically registers only the permission kits that are actually needed
     * based on the permissions specified in the configuration. This approach is more
     * efficient as it avoids instantiating and storing unused permission kits.
     *
     * **On-Demand Registration Benefits**:
     * - Memory efficiency: Only creates kits that will be used
     * - Faster initialization: Reduces startup time
     * - Resource optimization: Prevents unnecessary object creation
     * - Configuration-driven: Adapts to actual usage requirements
     *
     * - Parameter permissions: Array of PermissionItem objects from configuration
     *   specifying which permission types need to be registered
     *
     * **Registration Process**:
     * 1. Iterate through requested permission types
     * 2. Check if kit is already registered (avoid duplicate registration)
     * 3. Create and register kit instance for each required type
     * 4. Skip registration for already-registered or unsupported types
     *
     * **Thread Safety**: Should be called on the main thread before UI presentation
     */
    private func registerRequiredPermissionKits(for permissions: [PermissionItem]) {
        let requiredTypes = Set(permissions.map { $0.type })
        let alreadyRegistered = PermissionKitManager.shared.getRegisteredTypes()
        let toRegister = requiredTypes.subtracting(alreadyRegistered)
        
        // Log registration information for debugging
        if !toRegister.isEmpty {
            print("🔐 FlutterPermissionKit: Registering permission kits for types: \(toRegister.map { $0.rawValue }.joined(separator: ", "))")
        }
        
        if !alreadyRegistered.isEmpty {
            print("🔐 FlutterPermissionKit: Already registered kits: \(alreadyRegistered.map { $0.rawValue }.joined(separator: ", "))")
        }
        
        for permissionType in toRegister {
            // Register appropriate kit based on permission type
            switch permissionType {
            case .photos:
                let photosKit = PhotosPermissionKit()
                PermissionKitManager.shared.registerKit(photosKit)
                
            case .camera:
                let cameraKit = CameraPermissionKit()
                PermissionKitManager.shared.registerKit(cameraKit)
                
            case .microphone:
                let microphoneKit = MicrophonePermissionKit()
                PermissionKitManager.shared.registerKit(microphoneKit)
                
            case .speech:
                let speechKit = SpeechPermissionKit()
                PermissionKitManager.shared.registerKit(speechKit)
                
            case .contacts:
                let contactsKit = ContactsPermissionKit()
                PermissionKitManager.shared.registerKit(contactsKit)
                
            case .notification:
                let notificationKit = NotificationPermissionKit()
                PermissionKitManager.shared.registerKit(notificationKit)
                
            case .location:
                let locationKit = LocationPermissionKit()
                PermissionKitManager.shared.registerKit(locationKit)
                
            case .calendar:
                let calendarKit = CalendarPermissionKit()
                PermissionKitManager.shared.registerKit(calendarKit)
                
            case .tracking:
                let trackingKit = TrackingPermissionKit()
                PermissionKitManager.shared.registerKit(trackingKit)
                
            case .reminder:
                let reminderKit = ReminderPermissionKit()
                PermissionKitManager.shared.registerKit(reminderKit)
                
            case .bluetooth:
                let bluetoothKit = BluetoothPermissionKit()
                PermissionKitManager.shared.registerKit(bluetoothKit)
                
            case .music:
                let musicKit = MusicPermissionKit()
                PermissionKitManager.shared.registerKit(musicKit)
                
            case .siri:
                let siriKit = SiriPermissionKit()
                PermissionKitManager.shared.registerKit(siriKit)
            }
        }
        
        // Log final registration state
        let finalRegistered = PermissionKitManager.shared.getRegisteredTypes()
        print("🔐 FlutterPermissionKit: Total registered kits: \(finalRegistered.count) (\(finalRegistered.map { $0.rawValue }.joined(separator: ", ")))")
    }
    
    /**
     * Legacy method for registering all permission kits at once
     *
     * This method has been deprecated in favor of on-demand registration.
     * It's kept for backward compatibility and can be used if you need to
     * register all available permission kits regardless of configuration.
     *
     * **Deprecated**: Use registerRequiredPermissionKits(for:) instead
     * **Memory Impact**: Creates all permission kit instances regardless of usage
     * **Use Case**: Only use if you need all permission types available globally
     *
     * **Note**: This method is no longer called during initialization.
     * Call explicitly if you need all kits registered for any reason.
     */
    private func registerPermissionKits() {
        // Register photos permission kit for photo library access
        let photosKit = PhotosPermissionKit()
        PermissionKitManager.shared.registerKit(photosKit)
        
        // Register camera permission kit for camera access
        let cameraKit = CameraPermissionKit()
        PermissionKitManager.shared.registerKit(cameraKit)
        
        // Register microphone permission kit for audio recording
        let microphoneKit = MicrophonePermissionKit()
        PermissionKitManager.shared.registerKit(microphoneKit)
        
        // Register speech permission kit for speech recognition
        let speechKit = SpeechPermissionKit()
        PermissionKitManager.shared.registerKit(speechKit)
        
        // Register contracts permission kit for contact access
        let contactsKit = ContactsPermissionKit()
        PermissionKitManager.shared.registerKit(contactsKit)
        
        // Register notification permission kit for push notifications
        let notificationKit = NotificationPermissionKit()
        PermissionKitManager.shared.registerKit(notificationKit)
        
        // Register location permission kit for location access
        let locationKit = LocationPermissionKit()
        PermissionKitManager.shared.registerKit(locationKit)
        
        // Register calendar permission kit for calendar access
        let calendarKit = CalendarPermissionKit()
        PermissionKitManager.shared.registerKit(calendarKit)
        
        // Register tracking permission kit for AppTrackingTransparency
        let trackingKit = TrackingPermissionKit()
        PermissionKitManager.shared.registerKit(trackingKit)
        
        // Register reminder permission kit for reminder access
        let reminderKit = ReminderPermissionKit()
        PermissionKitManager.shared.registerKit(reminderKit)
        
        // Register bluetooth permission kit for bluetooth access
        let bluetoothKit = BluetoothPermissionKit()
        PermissionKitManager.shared.registerKit(bluetoothKit)
        
        // Register apple music permission kit for music access
        let musicKit = MusicPermissionKit()
        PermissionKitManager.shared.registerKit(musicKit)
        
        // Register siri permission kit fro siri access
        let siriKit = SiriPermissionKit()
        PermissionKitManager.shared.registerKit(siriKit)

        
        // TODO: Register more permission kit
    }
    
    /**
     * Initializes and handles permission kit request from Flutter layer
     *
     * This method serves as the main entry point for permission requests initiated
     * from the Flutter layer. It parses the configuration, checks existing permissions,
     * and either returns immediate success or presents the permission request interface.
     *
     * **Flow Logic**:
     * 1. Parse configuration data from method call arguments
     * 2. Check if all requested permissions are already granted
     * 3. If all granted, return success immediately (no UI needed)
     * 4. If permissions needed, present permission request interface
     * 5. Return success/failure based on UI presentation result
     *
     * - Parameters:
     *   - call: FlutterMethodCall containing configuration data from Flutter
     *   - result: Callback to return operation result to Flutter layer
     *
     * **Return Values**:
     * - `true`: Configuration parsed successfully and UI presented (or not needed)
     * - `false`: Configuration parsing failed or UI presentation failed
     *
     * **Error Handling**: Returns false for malformed configuration data,
     * allowing Flutter layer to handle errors appropriately.
     */
    func initPermissionKit(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Parse configuration data from Flutter method call
        guard let args = call.arguments as? [String: Any],
              let config = FlutterPermissionKitConfig(from: args) else {
            // Return failure if configuration parsing fails
            result(false)
            return
        }
        
        // Store configuration for use throughout permission flow
        self.config = config
        
        // Register only the permission kits needed based on configuration
        // This approach is more efficient than registering all kits upfront
        self.registerRequiredPermissionKits(for: config.permissions)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Check if all requested permissions are already granted
            if !self.checkPermissionsStatus(permissions: config.permissions).values.contains(.notDetermined) {
                // All permissions already granted, no UI needed
                result(true)
                return
            }
            
            // Present permission request UI and return result
            let showResult = self.showCorePermissionView()
            result(showResult)
        }
    }
    
    /**
     * Presents the permission request interface to the user
     *
     * This method creates and presents the SwiftUI-based permission request interface
     * according to the current configuration. It handles different presentation styles
     * and finds the appropriate view controller for presentation.
     *
     * **UI Creation Process**:
     * 1. Create CorePermissionView with configuration text and permission cards
     * 2. Wrap in UIHostingController for UIKit integration
     * 3. Configure presentation style based on display type
     * 4. Find topmost view controller for presentation
     * 5. Present the interface with appropriate modality
     *
     * - Returns: Boolean indicating whether UI presentation was successful
     *
     * **Presentation Styles**:
     * - **Modal (.modal)**: Form sheet style with secondary background color
     * - **Alert (.alert)**: Over full screen with clear background for overlay effect
     *
     * **Error Handling**: Returns false if no configuration available or no suitable
     * presenting view controller found.
     */
    func showCorePermissionView() -> Bool {
        // Ensure configuration is available
        guard let config = self.config else { return false }
        
        // Create the main permission request view with configuration
        let corePermissionView = CorePermissionView(
            displayTitle: config.displayTitle,
            displayHeaderDescription: config.displayHeaderDescription,
            displayBottomDescription: config.displayBottomDescription
        ) {
            // Generate permission cards for all requested permissions
            AnyView(self.renderPermissionCards(permissions: config.permissions))
        }
        
        // Wrap SwiftUI view in UIKit hosting controller
        let hostingController = UIHostingController(rootView: corePermissionView)
        self.hostingController = hostingController
        
        // Configure presentation style based on display type
        switch(config.displayType) {
        case .modal:
            // Form sheet style for custom modal presentation
            hostingController.modalPresentationStyle = .formSheet
            hostingController.view.backgroundColor = UIColor.secondarySystemBackground
        case .alert:
            // Over full screen for alert-style overlay
            hostingController.modalPresentationStyle = .overFullScreen
            hostingController.view.backgroundColor = UIColor.clear
        }
        
        // Prevent dismissal by swipe to ensure controlled permission flow
        hostingController.isModalInPresentation = true
        
        // Find topmost view controller and present permission interface
        if let topViewController = topMostViewController() {
            self.presentingViewController = topViewController
            topViewController.present(hostingController, animated: true)
            return true
        }
        
        // Return failure if no suitable presenting view controller found
        return false
    }
    
    /**
     * Renders permission cards for the requested permissions using ViewBuilder
     *
     * This ViewBuilder method generates the SwiftUI views for all requested permission
     * types by creating appropriate permission cards and handling cases where permission
     * kits are not available.
     *
     * **Card Generation Process**:
     * 1. Iterate through all requested permission items
     * 2. Look up registered permission kit for each type
     * 3. Generate permission card using kit's createPermissionCard method
     * 4. Handle completion callbacks to coordinate permission flow
     * 5. Show error message for unavailable permission types
     *
     * - Parameter permissions: Array of PermissionItem objects to render
     *
     * **Error Handling**: Shows red error text for permission types that don't have
     * registered kits, providing clear feedback about configuration issues.
     *
     * **Completion Coordination**: Each permission card calls handlePermissionsCompleted
     * when its permission status changes, enabling centralized completion handling.
     */
    @ViewBuilder
    func renderPermissionCards(permissions: [PermissionItem]) -> some View {
        ForEach(permissions, id: \.type) { item in
            // Look up registered permission kit for this permission type
            if let kit = PermissionKitManager.shared.getKit(for: item.type) {
                // Create permission card using the kit's factory method
                kit.createPermissionCard(
                    title: item.name,
                    description: item.description,
                    onPermissionsCompleted: {
                        // Handle completion when this permission is determined
                        self.handlePermissionsCompleted()
                    }
                )
            } else {
                // Show error message for unavailable permission types
                Text("Permission kit not available for \(item.type.rawValue)")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
    
    /**
     * Handles completion of permission requests and manages UI dismissal
     *
     * This method is called whenever a permission status changes from undetermined
     * to any determined state. It checks if all requested permissions have been
     * determined and dismisses the permission interface when complete.
     *
     * **Completion Logic**:
     * 1. Check current status of all requested permissions
     * 2. If any permissions still undetermined, continue waiting
     * 3. If all permissions determined, prepare for dismissal
     * 4. Disable modal presentation prevention
     * 5. Schedule dismissal with delay for smooth UX
     *
     * **UX Considerations**: Uses a 0.5 second delay before dismissal to allow
     * users to see the final permission status before the interface disappears.
     * This provides better visual feedback and prevents jarring transitions.
     */
    private func handlePermissionsCompleted() {
        // Check current status of all requested permissions
        let currentStatuses = checkPermissionsStatus()
        let hasUndeterminedPermissions = currentStatuses.values.contains(.notDetermined)
        
        // If any permissions still undetermined, wait for more changes
        if hasUndeterminedPermissions {
            return
        }
        
        // All permissions determined - prepare for dismissal
        if let hostingController = self.hostingController {
            // Allow dismissal by disabling modal presentation prevention
            hostingController.isModalInPresentation = false
        }
        
        // Schedule dismissal with delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismissModal()
        }
    }
    
    /**
     * Dismisses the permission request interface and cleans up references
     *
     * This method handles the dismissal of the permission request UI and performs
     * necessary cleanup to prevent memory leaks and maintain proper state.
     *
     * **Cleanup Process**:
     * 1. Dismiss the hosting controller with animation
     * 2. Clear hosting controller reference
     * 3. Clear presenting view controller reference
     * 4. Allow configuration to be garbage collected
     *
     * **Memory Management**: Clearing references prevents retain cycles and
     * ensures proper deallocation of UI components after permission flow completes.
     */
    private func dismissModal() {
        if let hostingController = self.hostingController {
            hostingController.dismiss(animated: true) {
                // Clear references after dismissal completes
                self.hostingController = nil
                self.presentingViewController = nil
            }
        }
    }
    
    /**
     * Checks current authorization status of requested permissions
     *
     * This method queries the current permission status for all requested permission
     * types and returns a dictionary mapping permission types to their current status.
     * Used for determining when permission flow is complete and for status reporting.
     *
     * **Status Checking Process**:
     * 1. Use provided permissions list or fall back to current configuration
     * 2. For each permission, look up its registered kit
     * 3. Query the kit's current permission status
     * 4. Map results into dictionary for easy lookup
     * 5. Return .denied for permission types without registered kits
     *
     * - Parameter permissions: Optional array of permissions to check (defaults to config permissions)
     *
     * - Returns: Dictionary mapping PermissionType to AuthorizationStatus
     *
     * **Error Handling**: Returns .denied status for permission types that don't have
     * registered kits, ensuring consistent behavior for incomplete configurations.
     *
     * **Use Cases**:
     * - Determining when permission flow is complete
     * - Checking permission status before showing features
     * - Reporting current permission state to Flutter layer
     */
    func checkPermissionsStatus(permissions: [PermissionItem]? = nil) -> [PermissionType: AuthorizationStatus] {
        // Use provided permissions or fall back to current configuration
        let targetPermissions = permissions ?? config?.permissions ?? []
        var permissionsStatus: [PermissionType: AuthorizationStatus] = [:]
        
        // Check status for each requested permission type
        targetPermissions.forEach { item in
            if let kit = PermissionKitManager.shared.getKit(for: item.type) {
                // Get current status from registered permission kit
                let status = kit.permissionStatus
                permissionsStatus[item.type] = status
            } else {
                // Return denied for permission types without registered kits
                permissionsStatus[item.type] = .denied
            }
        }
        
        return permissionsStatus
    }
    
    /**
     * Gets information about currently registered permission kits
     *
     * This method provides visibility into which permission kits are currently
     * registered and available for use. Useful for debugging, status reporting,
     * and understanding the current state of the permission system.
     *
     * - Returns: Set of PermissionType values representing currently registered kits
     *
     * **Use Cases**:
     * - Debugging: Verify expected kits are registered
     * - Status reporting: Report available permission types to Flutter layer
     * - Feature detection: Check if specific permission types are supported
     * - Testing: Validate kit registration in unit tests
     *
     * **Example**:
     * ```swift
     * let registeredTypes = CorePermissionKit.share.getRegisteredPermissionTypes()
     * print("Registered permission types: \(registeredTypes)")
     * // Output: [.camera, .photos] (only if these were requested in config)
     * ```
     */
    func getRegisteredPermissionTypes() -> Set<PermissionType> {
        return PermissionKitManager.shared.getRegisteredTypes()
    }
    
    /**
     * Finds the topmost view controller in the current app's view hierarchy
     *
     * This recursive method traverses the view controller hierarchy to find the
     * topmost presented view controller, which is the appropriate place to present
     * the permission request interface.
     *
     * **Traversal Logic**:
     * 1. Start from provided root or find key window's root view controller
     * 2. If navigation controller, get visible view controller
     * 3. If tab bar controller, get selected view controller
     * 4. If view controller has presented controller, traverse to presented controller
     * 5. Recursively apply logic until reaching topmost controller
     *
     * - Parameter root: Optional starting view controller (defaults to key window's root)
     *
     * - Returns: The topmost view controller suitable for presentation, or nil if none found
     *
     * **Window Scene Support**: Uses modern iOS window scene APIs to find the key window,
     * ensuring compatibility with iOS 13+ multi-scene applications.
     *
     * **Use Cases**:
     * - Finding appropriate view controller for modal presentation
     * - Ensuring permission UI appears above current content
     * - Handling complex navigation hierarchies (tabs, navigation, modals)
     */
    func topMostViewController(from root: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
            
            // Handle navigation controller by getting visible controller
            if let nav = root as? UINavigationController {
                return topMostViewController(from: nav.visibleViewController)
            }
            
            // Handle tab bar controller by getting selected controller
            if let tab = root as? UITabBarController {
                return topMostViewController(from: tab.selectedViewController)
            }
            
            // Handle presented view controllers by traversing to topmost
            if let presented = root?.presentedViewController {
                return topMostViewController(from: presented)
            }
            
            // Return current controller if no further traversal needed
            return root
        }
}
