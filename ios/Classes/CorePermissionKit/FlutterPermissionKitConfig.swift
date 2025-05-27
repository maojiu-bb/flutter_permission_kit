//
//  FlutterPermissionKitConfig.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Foundation

/// Represents a single permission item with its metadata
///
/// This struct encapsulates the information for a single permission request,
/// including optional display information and the required permission type.
struct PermissionItem {
    /// Optional display name for the permission
    let name: String?
    
    /// Optional description explaining why the permission is needed
    let description: String?
    
    /// The type of permission being requested
    let type: PermissionType
    
    /// Initializes a PermissionItem from a dictionary
    ///
    /// - Parameter dict: Dictionary containing permission data from Flutter
    /// - Returns: A PermissionItem instance, or nil if required data is missing
    init?(from dict: [String: Any]) {
        // name and description are optional (can be null from Dart)
        let name = dict["name"] as? String
        let description = dict["description"] as? String
        
        // type is required
        guard let typeString = dict["type"] as? String,
              let type = PermissionType(from: typeString) else {
            return nil
        }
        
        self.name = name
        self.description = description
        self.type = type
    }
}

/// Configuration object for Flutter Permission Kit
///
/// This struct contains all the configuration options for customizing the
/// appearance and behavior of permission request dialogs on iOS.
struct FlutterPermissionKitConfig {
    /// List of permissions to request from the user
    let permissions: [PermissionItem]
    
    /// How the permission request should be displayed
    let displayType: DisplayType
    
    /// The main title displayed at the top of the permission request
    let displayTitle: String
    
    /// Description text shown in the header section
    let displayHeaderDescription: String
    
    /// Description text shown at the bottom of the permission list
    let displayBottomDescription: String
    
    /// Initializes a FlutterPermissionKitConfig from a dictionary
    ///
    /// - Parameter dict: Dictionary containing configuration data from Flutter
    /// - Returns: A FlutterPermissionKitConfig instance, or nil if required data is missing
    init?(from dict: [String: Any]) {
        // Parse permissions array
        guard let permissionsArray = dict["permissions"] as? [[String: Any]] else {
            return nil
        }
        
        let permissions = permissionsArray.compactMap { PermissionItem(from: $0) }
        
        // Parse other required fields
        guard let displayTypeString = dict["displayType"] as? String,
              let displayType = DisplayType(from: displayTypeString),
              let displayTitle = dict["displayTitle"] as? String,
              let displayHeaderDescription = dict["displayHeaderDescription"] as? String,
              let displayBottomDescription = dict["displayBottomDescription"] as? String
        else {
            return nil
        }
        
        self.permissions = permissions
        self.displayType = displayType
        self.displayTitle = displayTitle
        self.displayHeaderDescription = displayHeaderDescription
        self.displayBottomDescription = displayBottomDescription
    }
}
