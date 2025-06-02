/// Enumeration of all supported permission types in Flutter Permission Kit
///
/// This enum defines the various system permissions that can be requested
/// through the Flutter Permission Kit. Each enum value corresponds to a
/// specific platform permission that requires user authorization.
///
/// The enum values are designed to be cross-platform compatible, meaning
/// they work consistently across iOS and Android platforms, though the
/// underlying implementation may differ between platforms.
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
/// Note: Additional permission types can be added to this enum as needed.
/// When adding new types, ensure corresponding implementations exist in
/// both iOS and Android native code.
enum PermissionType {
  /// Camera permission for taking photos and recording videos
  ///
  /// This permission allows the app to access the device's camera hardware
  /// for capturing photos, recording videos, and using camera-based features.
  ///
  /// Platform mappings:
  /// - iOS: NSCameraUsageDescription
  /// - Android: android.permission.CAMERA
  camera,

  /// Photo library/gallery access permission
  ///
  /// This permission allows the app to read and access photos and videos
  /// stored in the device's photo library or gallery. Required for features
  /// like photo selection, image editing, or media browsing.
  ///
  /// Platform mappings:
  /// - iOS: NSPhotoLibraryUsageDescription
  /// - Android: android.permission.READ_EXTERNAL_STORAGE
  photos,

  /// Microphone access permission for audio recording
  ///
  /// This permission allows the app to access the device's microphone for
  /// recording audio, voice recognition, phone calls, or any audio input
  /// functionality. Essential for voice-based features and communication apps.
  ///
  /// Platform mappings:
  /// - iOS: NSMicrophoneUsageDescription
  /// - Android: android.permission.RECORD_AUDIO
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
  /// Platform mappings:
  /// - iOS: NSSpeechRecognitionUsageDescription
  /// - Android: android.permission.RECORD_AUDIO (combined with speech service access)
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
  /// Platform mappings:
  /// - iOS: NSContactsUsageDescription
  /// - Android: android.permission.READ_CONTACTS
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
  /// Platform mappings:
  /// - iOS: User Notification authorization (UNUserNotificationCenter)
  /// - Android: Default granted (can be disabled by user in settings)
  ///
  /// Common use cases:
  /// - Push notifications for messages and updates
  /// - Local reminders and alarms
  /// - Breaking news and important alerts
  /// - Marketing and promotional messages
  ///
  /// Note: On iOS, this requires explicit user consent through system dialog.
  /// On Android, notifications are enabled by default but users can disable them.
  notification,

  /// Location access permission for GPS and location services
  ///
  /// This permission allows the app to access the device's location
  /// information using GPS, network-based location, and other location
  /// services. Can include both precise and approximate location data.
  ///
  /// Platform mappings:
  /// - iOS: NSLocationWhenInUseUsageDescription / NSLocationAlwaysAndWhenInUseUsageDescription
  /// - Android: android.permission.ACCESS_FINE_LOCATION / android.permission.ACCESS_COARSE_LOCATION
  ///
  /// Common use cases:
  /// - Maps and navigation features
  /// - Location-based search and recommendations
  /// - Weather information based on current location
  /// - Geotagging photos and posts
  /// - Find my device functionality
  ///
  /// Privacy considerations:
  /// - Consider requesting only when needed (not at app launch)
  /// - Provide clear explanation of why location is needed
  /// - Use appropriate precision level (coarse vs fine location)
  /// - Respect user's choice to deny or limit location access
  location,

  // Additional permission types can be added here as needed
  // Examples: calendar, reminders, health, motion, bluetooth, etc.
  // When adding new types, ensure proper documentation and platform mappings
}
