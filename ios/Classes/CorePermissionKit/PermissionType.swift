//
//  PermissionType.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Foundation

/// Enumeration of supported permission types for iOS platform
///
/// This enum defines the various system permissions that can be requested
/// through the Flutter Permission Kit on iOS devices. Each case corresponds
/// to a specific iOS permission that requires user authorization and has
/// associated Info.plist usage description requirements.
///
/// The enum provides a bridge between the Flutter layer's permission types
/// and the native iOS permission system, ensuring consistent handling
/// across the platform boundary.
///
/// Important: When adding new permission types, ensure that:
/// 1. Corresponding Info.plist usage descriptions are added
/// 2. Proper permission request handling is implemented
/// 3. The Flutter layer's PermissionType enum is updated accordingly
///
/// Example usage:
/// ```swift
/// let cameraType = PermissionType.camera
/// let photosType = PermissionType(from: "photos")
/// ```
enum PermissionType: String, CaseIterable {
    /// Camera access permission
    ///
    /// Allows the app to access the device's camera for taking photos,
    /// recording videos, and using camera-based features like QR code scanning.
    ///
    /// iOS Requirements:
    /// - Info.plist key: NSCameraUsageDescription
    /// - System permission: AVCaptureDevice authorization
    /// - User-facing permission dialog: "Allow [App] to access your camera?"
    ///
    /// Common use cases:
    /// - Taking profile pictures
    /// - Recording video content
    /// - QR/barcode scanning
    /// - Augmented reality features
    /// - Video calling functionality
    ///
    /// Example Info.plist entry:
    /// ```xml
    /// <key>NSCameraUsageDescription</key>
    /// <string>This app needs camera access to take photos and scan QR codes.</string>
    /// ```
    case camera
    
    /// Photo library access permission
    ///
    /// Allows the app to read and access photos and videos stored in the
    /// device's Photos app. This includes both user-created content and
    /// downloaded media files.
    ///
    /// iOS Requirements:
    /// - Info.plist key: NSPhotoLibraryUsageDescription
    /// - System permission: PHPhotoLibrary authorization
    /// - User-facing permission dialog: "Allow [App] to access your photos?"
    ///
    /// Common use cases:
    /// - Selecting photos for profile pictures
    /// - Importing images for editing
    /// - Sharing photos to social media
    /// - Creating photo collages or albums
    /// - Backing up photos to cloud services
    ///
    /// Note: iOS 14+ introduced limited photo access, allowing users to
    /// grant access to only selected photos rather than the entire library.
    ///
    /// Example Info.plist entry:
    /// ```xml
    /// <key>NSPhotoLibraryUsageDescription</key>
    /// <string>This app needs photo library access to select and share images.</string>
    /// ```
    case photos
    
    case microphone
    
    case speech
    
    case contracts
    
    // Additional permission types can be added here as needed
    // Examples that might be implemented:
    // - location: Location services access
    // - microphone: Audio recording access
    // - contacts: Address book access
    // - calendar: Calendar events access
    // - reminders: Reminders app access
    // - notifications: Push notification permission
    // ...
    
    /// Initializes a PermissionType from a string value
    ///
    /// This convenience initializer enables creation of PermissionType instances
    /// from string representations, which is essential for parsing configuration
    /// data received from the Flutter layer through the method channel.
    ///
    /// The string matching is case-sensitive and must exactly match the
    /// raw value of the enum cases.
    ///
    /// - Parameter string: The string representation of the permission type
    ///   Expected values: "camera", "photos", etc.
    ///
    /// - Returns: A PermissionType instance if the string matches a valid case,
    ///   or nil if the string doesn't correspond to any known permission type
    ///
    /// Example usage:
    /// ```swift
    /// let cameraType = PermissionType(from: "camera")     // Returns .camera
    /// let photosType = PermissionType(from: "photos")     // Returns .photos
    /// let invalidType = PermissionType(from: "invalid")   // Returns nil
    /// ```
    ///
    /// Error handling:
    /// ```swift
    /// guard let permissionType = PermissionType(from: receivedString) else {
    ///     print("Unknown permission type: \(receivedString)")
    ///     return
    /// }
    /// // Use permissionType safely
    /// ```
    init?(from string: String) {
        self.init(rawValue: string)
    }
}
