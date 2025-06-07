import 'package:flutter_permission_kit/enums/permission_type.dart';

/// Represents a single permission request with its metadata
///
/// This class encapsulates all the information needed to request and display
/// a specific permission to the user. It includes optional display information
/// that can be used to provide context about why the permission is needed.
///
/// Example usage:
/// ```dart
/// final cameraPermission = Permission(
///   name: 'Camera Access',
///   description: 'Allow the app to take photos and record videos',
///   type: PermissionType.camera,
/// );
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
