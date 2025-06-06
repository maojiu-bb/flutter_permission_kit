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
    
    /// Microphone access permission
    ///
    /// Allows the app to access the device's microphone for recording audio,
    /// voice recognition, phone calls, and any audio input functionality.
    /// Essential for voice-based features and real-time communication.
    ///
    /// iOS Requirements:
    /// - Info.plist key: NSMicrophoneUsageDescription
    /// - System permission: AVAudioSession record permission
    /// - User-facing permission dialog: "Allow [App] to access your microphone?"
    ///
    /// Common use cases:
    /// - Voice recording and audio notes
    /// - Voice-to-text functionality
    /// - Video calls and voice calls
    /// - Music recording and audio editing
    /// - Voice commands and dictation
    /// - Live streaming with audio
    ///
    /// Technical considerations:
    /// - Requires proper AVAudioSession configuration
    /// - May need background audio capabilities for continuous recording
    /// - Consider audio quality settings based on use case
    ///
    /// Example Info.plist entry:
    /// ```xml
    /// <key>NSMicrophoneUsageDescription</key>
    /// <string>This app needs microphone access to record voice messages and enable voice calls.</string>
    /// ```
    case microphone
    
    /// Speech recognition permission
    ///
    /// Allows the app to use speech recognition services to convert spoken
    /// words into text. Required for voice commands, dictation features,
    /// and voice-controlled interfaces using Apple's Speech framework.
    ///
    /// iOS Requirements:
    /// - Info.plist key: NSSpeechRecognitionUsageDescription
    /// - System permission: SFSpeechRecognizer authorization
    /// - User-facing permission dialog: "Allow [App] to send audio recordings to Apple to process speech recognition requests?"
    ///
    /// Common use cases:
    /// - Voice-to-text input fields
    /// - Voice commands and app control
    /// - Accessibility features for speech input
    /// - Language learning and pronunciation apps
    /// - Voice search functionality
    /// - Real-time transcription services
    ///
    /// Technical considerations:
    /// - Requires network connectivity for on-device processing fallback
    /// - Audio data may be sent to Apple's servers for processing
    /// - Consider privacy implications and data handling policies
    /// - Limited daily usage quotas may apply
    ///
    /// Example Info.plist entry:
    /// ```xml
    /// <key>NSSpeechRecognitionUsageDescription</key>
    /// <string>This app uses speech recognition to convert your voice into text for hands-free input.</string>
    /// ```
    case speech
    
    /// Contacts access permission
    ///
    /// Allows the app to read contact information stored in the device's
    /// Contacts app, including names, phone numbers, email addresses,
    /// and other contact details. Essential for social features and communication.
    ///
    /// iOS Requirements:
    /// - Info.plist key: NSContactsUsageDescription
    /// - System permission: CNContactStore authorization
    /// - User-facing permission dialog: "Allow [App] to access your contacts?"
    ///
    /// Common use cases:
    /// - Contact selection for messaging or calling
    /// - Social network integration and friend finding
    /// - Address book synchronization
    /// - Auto-complete functionality for user input
    /// - Emergency contact features
    /// - Business card scanning and contact creation
    ///
    /// Privacy considerations:
    /// - Contact data is highly sensitive personal information
    /// - Consider requesting only when necessary for core functionality
    /// - Implement proper data handling and storage practices
    /// - Be transparent about how contact data will be used
    ///
    /// Example Info.plist entry:
    /// ```xml
    /// <key>NSContactsUsageDescription</key>
    /// <string>This app needs access to your contacts to help you easily share content with friends.</string>
    /// ```
    case contracts
    
    /// Push notification permission
    ///
    /// Allows the app to display push notifications, local notifications,
    /// and alert banners to the user. Essential for user engagement,
    /// reminders, and real-time communication features.
    ///
    /// iOS Requirements:
    /// - No Info.plist key required (runtime permission only)
    /// - System permission: UNUserNotificationCenter authorization
    /// - User-facing permission dialog: "Allow [App] to send you notifications?"
    ///
    /// Available notification types:
    /// - Badge: App icon badge numbers
    /// - Sound: Notification sounds and alerts
    /// - Alert: Banner and lock screen notifications
    /// - Announcement: Siri announcement support (iOS 15+)
    /// - TimeSensitive: Time-sensitive notifications (iOS 15+)
    ///
    /// Common use cases:
    /// - Push notifications for messages and updates
    /// - Local reminders and alarms
    /// - Breaking news and important alerts
    /// - Social media interactions and mentions
    /// - E-commerce order updates and promotions
    /// - Calendar event reminders
    ///
    /// Best practices:
    /// - Request permission at the right moment (not at app launch)
    /// - Provide clear value proposition before requesting
    /// - Allow users to customize notification preferences
    /// - Respect user's notification settings and preferences
    ///
    /// Code example:
    /// ```swift
    /// UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
    /// ```
    case notification
    
    /// Location access permission
    ///
    /// Allows the app to access the device's location information using GPS,
    /// network-based location, and other location services. Can include both
    /// precise and approximate location data with various usage scenarios.
    ///
    /// iOS Requirements:
    /// - Info.plist key: NSLocationWhenInUseUsageDescription (for when-in-use access)
    /// - Info.plist key: NSLocationAlwaysAndWhenInUseUsageDescription (for always access)
    /// - System permission: CLLocationManager authorization
    /// - User-facing permission dialog: "Allow [App] to use your location?"
    ///
    /// Location authorization levels:
    /// - When In Use: Location access only when app is active
    /// - Always: Location access even when app is in background
    /// - Precise: Full GPS accuracy
    /// - Approximate: Reduced accuracy location (iOS 14+)
    ///
    /// Common use cases:
    /// - Maps and navigation features
    /// - Location-based search and recommendations
    /// - Weather information based on current location
    /// - Geotagging photos and social media posts
    /// - Find my device functionality
    /// - Location-based reminders and geofencing
    ///
    /// Privacy considerations:
    /// - Location is highly sensitive personal data
    /// - Request minimal necessary access (when-in-use vs always)
    /// - Provide clear explanation of location usage
    /// - Consider using approximate location when possible
    /// - Implement proper data handling and retention policies
    ///
    /// Example Info.plist entries:
    /// ```xml
    /// <key>NSLocationWhenInUseUsageDescription</key>
    /// <string>This app uses location to show nearby restaurants and provide directions.</string>
    /// <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    /// <string>This app uses location to provide location-based reminders even when not in use.</string>
    /// ```
    case location
    
    case calendar
    
    case tracking
    
    case reminder
    
    case bluetooth
    
    case music
    
    // Additional permission types can be added here as needed
    // Examples that might be implemented in future versions:
    // - calendar: Calendar events access (NSCalendarsUsageDescription)
    // - reminders: Reminders app access (NSRemindersUsageDescription)
    // - health: HealthKit data access (NSHealthShareUsageDescription)
    // - motion: Motion and fitness data (NSMotionUsageDescription)
    // - bluetooth: Bluetooth peripheral access (NSBluetoothAlwaysUsageDescription)
    // - faceID: Face ID authentication (NSFaceIDUsageDescription)
    // - mediaLibrary: Apple Music library access (NSAppleMusicUsageDescription)
    
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
    ///   Expected values: "camera", "photos", "microphone", "speech", "contracts", "notification", "location"
    ///
    /// - Returns: A PermissionType instance if the string matches a valid case,
    ///   or nil if the string doesn't correspond to any known permission type
    ///
    /// Example usage:
    /// ```swift
    /// let cameraType = PermissionType(from: "camera")        // Returns .camera
    /// let photosType = PermissionType(from: "photos")        // Returns .photos
    /// let microphoneType = PermissionType(from: "microphone") // Returns .microphone
    /// let invalidType = PermissionType(from: "invalid")      // Returns nil
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
