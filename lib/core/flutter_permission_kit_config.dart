import 'package:flutter_permission_kit/core/permission.dart';
import 'package:flutter_permission_kit/enums/display_type.dart';

/// Configuration class for Flutter Permission Kit
///
/// This class contains all the configuration options for customizing the
/// appearance and behavior of permission request dialogs. It allows you to
/// specify which permissions to request, how they should be displayed,
/// and various UI customization options.
///
/// Example usage:
/// ```dart
/// // Using custom permission names and descriptions
/// final config = FlutterPermissionKitConfig(
///   permissions: [
///     Permission(
///       name: 'Camera',
///       description: 'Take photos and videos',
///       type: PermissionType.camera,
///     ),
///   ],
///   displayType: DisplayType.modal,
///   displayTitle: 'App Permissions',
/// );
///
/// // Using convenient static methods (name and description will be null)
/// final quickConfig = FlutterPermissionKitConfig(
///   permissions: [
///     Permission.camera,
///     Permission.photos,
///     Permission.microphone,
///   ],
///   displayType: DisplayType.alert,
///   displayTitle: 'Required Permissions',
/// );
/// ```
class FlutterPermissionKitConfig {
  /// List of permissions to request from the user
  ///
  /// This is a required list containing all the permissions that should be
  /// requested in this permission flow. Each Permission object contains
  /// the permission type and optional display information.
  final List<Permission> permissions;

  /// How the permission request should be displayed to the user
  ///
  /// Determines whether to show an alert dialog or a full-screen modal.
  /// Defaults to [DisplayType.alert] for a more native feel.
  final DisplayType displayType;

  /// The main title displayed at the top of the permission request
  ///
  /// This is the primary heading that users will see when the permission
  /// request appears. Should be concise and descriptive.
  /// Defaults to 'Permission Request'.
  final String displayTitle;

  /// Description text shown in the header section
  ///
  /// This appears below the title and provides context about why
  /// permissions are being requested. Can be used to explain the
  /// overall purpose or benefit of granting the permissions.
  /// Defaults to an empty string.
  final String displayHeaderDescription;

  /// Description text shown at the bottom of the permission list
  ///
  /// This appears after all permission items and can be used for
  /// additional information, privacy notes, or reassurances about
  /// data usage. Defaults to an empty string.
  final String displayBottomDescription;

  /// Creates a new FlutterPermissionKitConfig instance
  ///
  /// [permissions] is required and must contain at least one permission.
  /// All other parameters are optional and have sensible defaults.
  ///
  /// The default configuration provides a good starting point for most apps:
  /// - Alert-style display for native feel
  /// - iOS-style blue primary color
  /// - Auto-dismiss and auto-check enabled for better UX
  FlutterPermissionKitConfig({
    required this.permissions,
    this.displayType = DisplayType.alert,
    this.displayTitle = 'Permission Request',
    this.displayHeaderDescription =
        'To provide key features and a seamless experience, we require access to certain permissions.',
    this.displayBottomDescription =
        'Permissions can be managed later in Settings if you change your mind.',
  });

  /// Converts this FlutterPermissionKitConfig instance to a JSON-serializable Map
  ///
  // ignore: unintended_html_in_doc_comment
  /// This method serializes the entire configuration object into a Map<String, dynamic>
  /// format suitable for JSON conversion. This is essential for passing configuration
  /// data to native platform code through method channels, storing settings in files,
  /// or transmitting configuration over network connections.
  ///
  /// The serialization process handles complex data types appropriately:
  /// - Permission objects are converted using their individual toJson() methods
  /// - Enum values are converted to their string representations
  /// - Color objects are converted to their string representation
  /// - Primitive types (String, bool) are preserved as-is
  ///
  /// Returns a Map containing all configuration properties:
  /// - 'permissions': Array of serialized Permission objects
  /// - 'displayType': String representation of the DisplayType enum (e.g., "alert", "modal")
  /// - 'displayTitle': The main title text for the permission dialog
  /// - 'displayHeaderDescription': Header description text explaining the permission request
  /// - 'displayBottomDescription': Footer description text with additional information
  /// - 'primaryColor': String representation of the Color object (e.g., "Color(0xff007aff)")
  /// - 'autoDismiss': Boolean indicating whether to auto-dismiss the dialog
  /// - 'autoCheck': Boolean indicating whether to auto-check permission status
  ///
  /// Example output:
  /// ```json
  /// {
  ///   "permissions": [
  ///     {
  ///       "name": "Camera Access",
  ///       "description": "Take photos and videos",
  ///       "type": "camera"
  ///     }
  ///   ],
  ///   "displayType": "alert",
  ///   "displayTitle": "App Permissions",
  ///   "displayHeaderDescription": "We need these permissions...",
  ///   "displayBottomDescription": "You can change these later...",
  /// }
  /// ```
  ///
  /// This serialized format ensures that all configuration data can be reliably
  /// transmitted to platform-specific code and reconstructed as needed.
  Map<String, dynamic> toJson() => {
    'permissions': permissions.map((e) => e.toJson()).toList(),
    'displayType': displayType.name,
    'displayTitle': displayTitle,
    'displayHeaderDescription': displayHeaderDescription,
    'displayBottomDescription': displayBottomDescription,
  };
}
