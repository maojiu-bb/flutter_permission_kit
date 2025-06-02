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

  microphone,

  speech,

  // Additional permission types can be added here as needed
  // Examples: location, microphone, contacts, calendar, etc.
  // ...
}
