//
//  FlutterPermissionKitConfig.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Foundation

/**
 * PermissionItem
 * 
 * A data structure representing a single permission request with its associated metadata.
 * This struct serves as a bridge between the Flutter layer's permission configuration
 * and the iOS native permission system, encapsulating all necessary information for
 * displaying and processing individual permission requests.
 * 
 * **Purpose**:
 * - Encapsulates permission request data from Flutter layer
 * - Provides optional customization for permission display text
 * - Maps Flutter permission types to iOS PermissionType enum
 * - Enables dynamic permission request configuration
 * 
 * **Data Flow**: Flutter → JSON → Dictionary → PermissionItem → iOS UI
 * 
 * **Example Flutter Configuration**:
 * ```dart
 * PermissionItem(
 *   type: PermissionType.camera,
 *   name: "Camera Access",
 *   description: "Take photos and record videos"
 * )
 * ```
 */
struct PermissionItem {
    /**
     * Optional display name for the permission
     * 
     * Custom title text that will be displayed in the permission card UI.
     * If nil, the permission kit will use its default title (e.g., "Camera", "Photo Library").
     * This allows Flutter developers to customize permission display names based on
     * their app's context and user experience requirements.
     * 
     * **Flutter Mapping**: Corresponds to the `name` field in Flutter's PermissionItem
     * **UI Impact**: Displayed as the main heading in the permission card
     * **Default Behavior**: Uses permission type's default name when nil
     * 
     * **Example**: "Camera Access" instead of default "Camera"
     */
    let name: String?
    
    /**
     * Optional description explaining why the permission is needed
     * 
     * Custom explanatory text that helps users understand why the app needs
     * this specific permission. If nil, the permission kit will use its default
     * description. This is crucial for improving permission grant rates by
     * providing clear, contextual explanations.
     * 
     * **Flutter Mapping**: Corresponds to the `description` field in Flutter's PermissionItem
     * **UI Impact**: Displayed as secondary text below the permission title
     * **Default Behavior**: Uses permission type's default description when nil
     * **Best Practice**: Should be concise but informative about the specific use case
     * 
     * **Example**: "Take photos for your profile and share memories with friends"
     */
    let description: String?
    
    /**
     * The type of permission being requested
     * 
     * Identifies which iOS system permission this item represents (camera, photos, etc.).
     * This is the only required field and determines which permission kit will handle
     * the request and what system APIs will be called.
     * 
     * **Flutter Mapping**: Corresponds to the `type` field in Flutter's PermissionType enum
     * **iOS Integration**: Maps to iOS-specific permission APIs (AVFoundation, Photos, etc.)
     * **Required**: This field must be present and valid for the permission item to be created
     * 
     * **Supported Types**: camera, photos (extensible for future permission types)
     */
    let type: PermissionType
    
    /**
     * Initializes a PermissionItem from a dictionary received from Flutter
     * 
     * This failable initializer parses the dictionary data sent from the Flutter layer
     * via the method channel and creates a strongly-typed PermissionItem instance.
     * The parsing handles optional fields gracefully while ensuring required data is present.
     * 
     * **Data Validation**:
     * - `name` and `description` are optional and can be null/missing
     * - `type` is required and must map to a valid PermissionType
     * - Invalid or missing required data results in nil return
     * 
     * - Parameter dict: Dictionary containing permission data from Flutter
     *   Expected keys: "name" (optional), "description" (optional), "type" (required)
     * 
     * - Returns: A PermissionItem instance if parsing succeeds, nil if required data is missing or invalid
     * 
     * **Expected Dictionary Structure**:
     * ```json
     * {
     *   "name": "Camera Access",           // Optional String
     *   "description": "Take photos...",   // Optional String  
     *   "type": "camera"                   // Required String
     * }
     * ```
     * 
     * **Error Handling**: Returns nil for malformed data, allowing calling code to handle errors gracefully
     */
    init?(from dict: [String: Any]) {
        // Parse optional fields - these can be null from Dart/Flutter
        let name = dict["name"] as? String
        let description = dict["description"] as? String
        
        // Parse required type field and validate it maps to a known PermissionType
        guard let typeString = dict["type"] as? String,
              let type = PermissionType(from: typeString) else {
            // Return nil if type is missing or invalid - this is a critical error
            return nil
        }
        
        self.name = name
        self.description = description
        self.type = type
    }
}

/**
 * FlutterPermissionKitConfig
 * 
 * A comprehensive configuration object that encapsulates all settings and data needed
 * to display and manage the permission request interface. This struct serves as the
 * primary data model for communication between the Flutter layer and iOS native code.
 * 
 * **Architecture Role**:
 * - **Data Transfer Object**: Carries configuration from Flutter to iOS
 * - **UI Configuration**: Contains all text and display settings for the permission interface
 * - **Permission Registry**: Lists all permissions to be requested in the current flow
 * - **Presentation Control**: Determines how the permission UI should be displayed
 * 
 * **Key Features**:
 * - **Type Safety**: Strongly-typed configuration prevents runtime errors
 * - **Flexibility**: Supports custom text for all UI elements
 * - **Extensibility**: Easy to add new configuration options
 * - **Validation**: Built-in parsing validation ensures data integrity
 * 
 * **Usage Flow**:
 * 1. Flutter layer creates configuration object
 * 2. Configuration is serialized and sent via method channel
 * 3. iOS parses dictionary into FlutterPermissionKitConfig
 * 4. Configuration drives permission UI creation and behavior
 */
struct FlutterPermissionKitConfig {
    /**
     * List of permissions to request from the user
     * 
     * An array of PermissionItem objects representing all the permissions that
     * should be displayed and requested in the current permission flow. Each item
     * contains the permission type and optional customization data.
     * 
     * **UI Impact**: Determines how many permission cards are displayed
     * **Processing**: Each item is processed by its corresponding permission kit
     * **Order**: Items are displayed in the order they appear in this array
     * **Validation**: Only items with valid PermissionTypes are included
     * 
     * **Example**: [camera permission, photos permission] for a photo app
     */
    let permissions: [PermissionItem]
    
    /**
     * How the permission request interface should be displayed
     * 
     * Controls the presentation style of the permission request UI, affecting
     * the visual appearance and user interaction patterns. This allows Flutter
     * developers to choose the most appropriate presentation for their app's UX.
     * 
     * **Display Options**:
     * - `.modal`: Full-screen or sheet-style presentation with custom UI
     * - `.alert`: Native iOS alert-style presentation
     * 
     * **UI Impact**: Affects modal presentation style, background, and animations
     * **UX Consideration**: Modal provides more space for explanation, alert is more native
     */
    let displayType: DisplayType
    
    /**
     * The main title displayed at the top of the permission request interface
     * 
     * Primary heading text that introduces the permission request flow to users.
     * This should be clear, concise, and explain the overall purpose of the
     * permission requests that follow.
     * 
     * **UI Location**: Top of the permission interface, prominently displayed
     * **Typography**: Large, bold text that draws attention
     * **Content Guidelines**: Should be action-oriented and user-friendly
     * 
     * **Example**: "Grant Permissions", "App Permissions Required", "Enable Features"
     */
    let displayTitle: String
    
    /**
     * Description text shown in the header section
     * 
     * Explanatory text that appears below the main title and provides context
     * for why the app is requesting permissions. This is crucial for improving
     * user understanding and permission grant rates.
     * 
     * **UI Location**: Below the main title, before the permission cards
     * **Purpose**: Explains the overall benefit or necessity of granting permissions
     * **Length**: Should be concise but informative (1-2 sentences ideal)
     * **Tone**: Friendly and transparent about permission usage
     * 
     * **Example**: "To provide the best experience, this app needs access to the following features."
     */
    let displayHeaderDescription: String
    
    /**
     * Description text shown at the bottom of the permission list
     * 
     * Additional explanatory or reassuring text that appears after all permission
     * cards. Often used for privacy assurances, additional context, or next steps
     * information.
     * 
     * **UI Location**: Below all permission cards, at the bottom of the interface
     * **Purpose**: Provides final context, reassurance, or instructions
     * **Common Uses**: Privacy statements, "You can change these later" messages
     * **Optional Content**: Can be empty if no additional context is needed
     * 
     * **Example**: "You can modify these permissions anytime in Settings."
     */
    let displayBottomDescription: String
    
    /**
     * Initializes a FlutterPermissionKitConfig from a dictionary received from Flutter
     * 
     * This failable initializer parses the complete configuration dictionary sent
     * from Flutter and creates a strongly-typed configuration object. It handles
     * nested data structures (permissions array) and validates all required fields.
     * 
     * **Parsing Process**:
     * 1. Extracts and validates permissions array
     * 2. Parses each permission item, filtering out invalid entries
     * 3. Validates display type string and converts to enum
     * 4. Extracts all required text fields
     * 5. Returns nil if any required field is missing or invalid
     * 
     * - Parameter dict: Dictionary containing complete configuration from Flutter
     *   Must contain all required fields with correct types
     * 
     * - Returns: A FlutterPermissionKitConfig instance if parsing succeeds, nil otherwise
     * 
     * **Expected Dictionary Structure**:
     * ```json
     * {
     *   "permissions": [
     *     {"type": "camera", "name": "Camera", "description": "..."},
     *     {"type": "photos", "name": "Photos", "description": "..."}
     *   ],
     *   "displayType": "modal",
     *   "displayTitle": "Grant Permissions",
     *   "displayHeaderDescription": "This app needs...",
     *   "displayBottomDescription": "You can change..."
     * }
     * ```
     * 
     * **Error Handling**: Returns nil for malformed data, allowing graceful error handling
     * **Data Integrity**: Validates all fields to prevent runtime errors in UI components
     */
    init?(from dict: [String: Any]) {
        // Parse and validate the permissions array
        guard let permissionsArray = dict["permissions"] as? [[String: Any]] else {
            return nil
        }
        
        // Convert permission dictionaries to PermissionItem objects, filtering out invalid entries
        let permissions = permissionsArray.compactMap { PermissionItem(from: $0) }
        
        // Parse and validate all other required configuration fields
        guard let displayTypeString = dict["displayType"] as? String,
              let displayType = DisplayType(from: displayTypeString),
              let displayTitle = dict["displayTitle"] as? String,
              let displayHeaderDescription = dict["displayHeaderDescription"] as? String,
              let displayBottomDescription = dict["displayBottomDescription"] as? String
        else {
            return nil
        }
        
        // Initialize with validated data
        self.permissions = permissions
        self.displayType = displayType
        self.displayTitle = displayTitle
        self.displayHeaderDescription = displayHeaderDescription
        self.displayBottomDescription = displayBottomDescription
    }
}
