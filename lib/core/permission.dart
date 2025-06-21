import 'package:flutter_permission_kit/enums/permission_type.dart';

/// Represents a single permission request with its metadata
///
/// This class encapsulates all the information needed to request and display
/// a specific permission to the user. It includes optional display information
/// that can be used to provide context about why the permission is needed.
///
/// Example usage:
/// ```dart
/// // Using constructor with custom name and description
/// final cameraPermission = Permission(
///   name: 'Camera Access',
///   description: 'Allow the app to take photos and record videos',
///   type: PermissionType.camera,
/// );
///
/// // Using static convenience methods (name and description will be null)
/// final cameraPermission = Permission.camera;
/// final photosPermission = Permission.photos;
/// final microphonePermission = Permission.microphone;
/// ```
class Permission {
  /// The display name for this permission
  ///
  /// This is a user-friendly name that will be shown in the permission
  /// request dialog. If null, a default name based on the permission type
  /// will be used. Examples: "Camera Access", "Location Services", etc.
  final String? name;

  /// A detailed description explaining why this permission is needed
  ///
  /// This description helps users understand the purpose of the permission
  /// request and how the app will use the granted access. It should be
  /// clear, concise, and explain the benefit to the user.
  /// Example: "Allow the app to access your camera to take profile pictures"
  final String? description;

  /// The type of permission being requested
  ///
  /// This specifies which system permission is being requested (camera,
  /// location, microphone, etc.). This is required and determines the
  /// actual platform permission that will be requested.
  final PermissionType type;

  /// Creates a new Permission instance
  ///
  /// [type] is required and specifies which permission to request.
  /// [name] and [description] are optional but recommended for better UX.
  Permission({this.name, this.description, required this.type});

  // Static convenience methods for creating Permission instances
  // These methods create Permission instances with null name and description
  // for quick and easy permission creation without custom text.

  /// Creates a camera permission with no custom name or description
  ///
  /// This creates a Permission instance for camera access without any
  /// custom display text. The platform will use default names and descriptions.
  ///
  /// Example:
  /// ```dart
  /// final config = FlutterPermissionKitConfig(
  ///   permissions: [Permission.camera, Permission.photos],
  /// );
  /// ```
  static Permission get camera => Permission(type: PermissionType.camera);

  /// Creates a photos permission with no custom name or description
  ///
  /// This creates a Permission instance for photo library access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get photos => Permission(type: PermissionType.photos);

  /// Creates a microphone permission with no custom name or description
  ///
  /// This creates a Permission instance for microphone access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get microphone =>
      Permission(type: PermissionType.microphone);

  /// Creates a speech recognition permission with no custom name or description
  ///
  /// This creates a Permission instance for speech recognition access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get speech => Permission(type: PermissionType.speech);

  /// Creates a contacts permission with no custom name or description
  ///
  /// This creates a Permission instance for contacts access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get contacts => Permission(type: PermissionType.contacts);

  /// Creates a notification permission with no custom name or description
  ///
  /// This creates a Permission instance for notification access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get notification =>
      Permission(type: PermissionType.notification);

  /// Creates a location permission with no custom name or description
  ///
  /// This creates a Permission instance for location access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get location => Permission(type: PermissionType.location);

  /// Creates a calendar permission with no custom name or description
  ///
  /// This creates a Permission instance for calendar access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get calendar => Permission(type: PermissionType.calendar);

  /// Creates a tracking permission with no custom name or description
  ///
  /// This creates a Permission instance for tracking access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get tracking => Permission(type: PermissionType.tracking);

  /// Creates a reminder permission with no custom name or description
  ///
  /// This creates a Permission instance for reminder access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get reminder => Permission(type: PermissionType.reminder);

  /// Creates a bluetooth permission with no custom name or description
  ///
  /// This creates a Permission instance for bluetooth access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get bluetooth => Permission(type: PermissionType.bluetooth);

  /// Creates a music permission with no custom name or description
  ///
  /// This creates a Permission instance for Apple Music access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get music => Permission(type: PermissionType.music);

  /// Creates a Siri permission with no custom name or description
  ///
  /// This creates a Permission instance for Siri access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get siri => Permission(type: PermissionType.siri);

  /// Creates a health permission with no custom name or description
  ///
  /// This creates a Permission instance for health data access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get health => Permission(type: PermissionType.health);

  /// Creates a motion permission with no custom name or description
  ///
  /// This creates a Permission instance for motion and fitness data access without any
  /// custom display text. The platform will use default names and descriptions.
  static Permission get motion => Permission(type: PermissionType.motion);

  /// Converts this Permission instance to a JSON-serializable Map
  ///
  // ignore: unintended_html_in_doc_comment
  /// This method serializes the Permission object into a Map<String, dynamic>
  /// format that can be easily converted to JSON for storage, transmission,
  /// or communication with platform channels. This is particularly useful
  /// when passing permission data to native platform code or storing
  /// configuration in files.
  ///
  /// Returns a Map containing:
  /// - 'name': The display name of the permission (nullable String)
  /// - 'description': The detailed description of why this permission is needed (nullable String)
  /// - 'type': The permission type as a string representation (non-null String)
  ///
  /// Example output:
  /// ```json
  /// {
  ///   "name": "Camera Access",
  ///   "description": "Allow the app to take photos and record videos",
  ///   "type": "camera"
  /// }
  /// ```
  ///
  /// Note: Null values for name and description will be preserved in the Map,
  /// allowing the receiving code to handle them appropriately.
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'type': type.name,
  };
}
