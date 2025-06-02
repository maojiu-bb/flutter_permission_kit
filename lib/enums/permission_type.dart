/// Enumeration of all supported permission types in Flutter Permission Kit
///
/// This enum defines the various system permissions that can be requested
/// through the Flutter Permission Kit on iOS platform. Each enum value corresponds
/// to a specific iOS permission that requires user authorization and proper
/// Info.plist configuration.
///
/// The enum values are designed to work with iOS system permissions, utilizing
/// the appropriate iOS frameworks and authorization mechanisms for each permission type.
///
/// Example usage:
/// ```dart
/// final cameraPermission = Permission(
///   name: 'Camera Access',
///   description: 'Allow the app to take photos and record videos',
///   type: PermissionType.camera,
/// );
/// ```
///
/// Important: When adding new permission types, ensure:
/// - Corresponding Info.plist usage descriptions are added
/// - iOS native implementation exists in the permission kit
/// - Proper iOS framework integration is implemented
enum PermissionType {
  /// Camera permission for taking photos and recording videos
  ///
  /// This permission allows the app to access the device's camera hardware
  /// for capturing photos, recording videos, and using camera-based features.
  ///
  /// iOS Requirements:
  /// - Info.plist key: NSCameraUsageDescription
  /// - Framework: AVFoundation (AVCaptureDevice)
  /// - User dialog: "Allow [App] to access your camera?"
  camera,

  /// Photo library/gallery access permission
  ///
  /// This permission allows the app to read and access photos and videos
  /// stored in the device's Photos app. Required for features like photo
  /// selection, image editing, or media browsing.
  ///
  /// iOS Requirements:
  /// - Info.plist key: NSPhotoLibraryUsageDescription
  /// - Framework: Photos (PHPhotoLibrary)
  /// - User dialog: "Allow [App] to access your photos?"
  /// - Note: iOS 14+ supports limited photo access
  photos,

  /// Microphone access permission for audio recording
  ///
  /// This permission allows the app to access the device's microphone for
  /// recording audio, voice recognition, phone calls, or any audio input
  /// functionality. Essential for voice-based features and communication apps.
  ///
  /// iOS Requirements:
  /// - Info.plist key: NSMicrophoneUsageDescription
  /// - Framework: AVFoundation (AVAudioSession)
  /// - User dialog: "Allow [App] to access your microphone?"
  ///
  /// Common use cases:
  /// - Voice recording and audio notes
  /// - Voice-to-text functionality
  /// - Video calls and voice calls
  /// - Music recording and audio editing
  microphone,

  /// Speech recognition permission for voice processing
  ///
  /// This permission allows the app to use speech recognition services
  /// to convert spoken words into text. Required for voice commands,
  /// dictation features, and voice-controlled interfaces.
  ///
  /// iOS Requirements:
  /// - Info.plist key: NSSpeechRecognitionUsageDescription
  /// - Framework: Speech (SFSpeechRecognizer)
  /// - User dialog: "Allow [App] to send audio recordings to Apple to process speech recognition requests?"
  /// - Note: Requires network connectivity for processing
  ///
  /// Common use cases:
  /// - Voice-to-text input fields
  /// - Voice commands and app control
  /// - Accessibility features for speech input
  /// - Language learning and pronunciation apps
  speech,

  /// Contacts access permission for reading contact information
  ///
  /// This permission allows the app to read contact information stored
  /// on the device, including names, phone numbers, email addresses,
  /// and other contact details. Required for social features and communication.
  ///
  /// iOS Requirements:
  /// - Info.plist key: NSContactsUsageDescription
  /// - Framework: Contacts (CNContactStore)
  /// - User dialog: "Allow [App] to access your contacts?"
  ///
  /// Common use cases:
  /// - Contact selection for messaging or calling
  /// - Social network integration
  /// - Address book synchronization
  /// - Friend finding and invitation features
  contracts,

  /// Push notification permission for sending notifications
  ///
  /// This permission allows the app to display push notifications,
  /// local notifications, and alert banners to the user. Essential
  /// for engagement, reminders, and real-time communication features.
  ///
  /// iOS Requirements:
  /// - No Info.plist key required (runtime permission only)
  /// - Framework: UserNotifications (UNUserNotificationCenter)
  /// - User dialog: "Allow [App] to send you notifications?"
  /// - Available options: Alert, Badge, Sound, Announcement, TimeSensitive
  ///
  /// Common use cases:
  /// - Push notifications for messages and updates
  /// - Local reminders and alarms
  /// - Breaking news and important alerts
  /// - Marketing and promotional messages
  ///
  /// Note: Requires explicit user consent through system dialog.
  /// Users can customize notification settings in device Settings app.
  notification,

  /// Location access permission for GPS and location services
  ///
  /// This permission allows the app to access the device's location
  /// information using GPS, network-based location, and other location
  /// services. Can include both precise and approximate location data.
  ///
  /// iOS Requirements:
  /// - Info.plist key: NSLocationWhenInUseUsageDescription (when-in-use access)
  /// - Info.plist key: NSLocationAlwaysAndWhenInUseUsageDescription (always access)
  /// - Framework: CoreLocation (CLLocationManager)
  /// - User dialog: "Allow [App] to use your location?"
  /// - Authorization levels: When In Use, Always, Precise/Approximate (iOS 14+)
  ///
  /// Common use cases:
  /// - Maps and navigation features
  /// - Location-based search and recommendations
  /// - Weather information based on current location
  /// - Geotagging photos and posts
  /// - Find my device functionality
  ///
  /// Privacy considerations:
  /// - Request minimal necessary access (when-in-use vs always)
  /// - Provide clear explanation of location usage
  /// - Consider using approximate location when possible
  /// - Respect user's choice to deny or limit location access
  location,

  /// Calendar access permission for reading and writing calendar events
  ///
  /// This permission allows the app to read and write calendar events,
  /// including creating, modifying, and deleting events. Required for
  /// calendar integration and scheduling features.
  ///
  /// iOS Requirements:
  /// - Info.plist key: NSCalendarsUsageDescription
  /// - Framework: EventKit (EKEventStore)
  /// - User dialog: "Allow [App] to access your calendar?"
  ///
  /// Common use cases:
  /// - Event creation and management
  /// - Calendar synchronization
  /// - Meeting scheduling integration
  /// - Reminder and appointment features
  calendar,

  /// Tracking access permission for tracking user activity
  ///
  /// This permission allows the app to track user activity, including
  /// app usage, location, and other device-related information. Required
  /// for analytics, user tracking, and personalized features.
  ///
  tracking,

  // Additional permission types can be added here as needed
  // Examples: reminders, health, motion, bluetooth, faceID, etc.
  // When adding new types, ensure proper iOS documentation and Info.plist mappings
}
