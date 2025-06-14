import 'package:flutter_permission_kit/core/flutter_permission_kit_channel.dart';
import 'package:flutter_permission_kit/core/flutter_permission_kit_config.dart';
import 'package:flutter_permission_kit/enums/authoricate_status.dart';
import 'package:flutter_permission_kit/enums/permission_type.dart';

/// Main entry point for Flutter Permission Kit functionality
///
/// This class provides a high-level API for managing permission requests in iOS
/// Flutter applications. It implements the singleton pattern to ensure consistent
/// state management and prevent multiple instances from interfering with each other.
///
/// The class serves as a facade that simplifies the iOS permission request process by:
/// - Providing a simple, developer-friendly API
/// - Managing the underlying platform channel communication with iOS
/// - Handling configuration validation and setup for iOS permissions
/// - Ensuring proper initialization before permission requests
/// - Supporting iOS-specific permission features and behaviors
///
/// Key features:
/// - iOS permission handling with native iOS frameworks
/// - Customizable UI for permission request dialogs
/// - Automatic permission status checking
/// - Configurable auto-dismiss behavior
/// - Support for multiple permission types in a single request
/// - Integration with iOS Info.plist requirements
///
/// Example usage:
/// ```dart
/// // Initialize the permission kit with configuration
/// final success = await FlutterPermissionKit.init(
///   config: FlutterPermissionKitConfig(
///     displayType: DisplayType.alert,
///     displayTitle: 'App Permissions',
///     displayHeaderDescription: 'We need access to provide you with the best experience',
///     permissions: [
///       Permission(
///         name: 'Camera Access',
///         description: 'Take photos and record videos',
///         type: PermissionType.camera,
///       ),
///       Permission(
///         name: 'Photo Library',
///         description: 'Select photos from your gallery',
///         type: PermissionType.photos,
///       ),
///     ],
///   ),
/// );
///
/// if (success) {
///   print('Permission kit initialized successfully');
/// } else {
///   print('Failed to initialize permission kit');
/// }
/// ```
class FlutterPermissionKit {
  /// Private singleton instance
  ///
  /// This ensures that only one instance of FlutterPermissionKit exists
  /// throughout the application lifecycle, preventing state conflicts
  /// and ensuring consistent behavior across the app.
  static final FlutterPermissionKit _instance =
      FlutterPermissionKit._internal();

  /// Factory constructor that returns the singleton instance
  ///
  /// This is the recommended way to access the FlutterPermissionKit instance.
  /// Multiple calls to this constructor will always return the same instance.
  ///
  /// Returns the singleton FlutterPermissionKit instance.
  factory FlutterPermissionKit() => _instance;

  /// Private internal constructor
  ///
  /// This prevents external instantiation of the class, enforcing the
  /// singleton pattern. Only the factory constructor can create instances.
  FlutterPermissionKit._internal();

  /// Initializes the Flutter Permission Kit with the provided configuration for iOS
  ///
  /// This method must be called before attempting to request any permissions.
  /// It sets up the native iOS platform code with the specified configuration,
  /// including UI customization options, permission list, and behavior settings.
  ///
  /// The initialization process involves:
  /// 1. Validating the provided configuration
  /// 2. Serializing the configuration for platform transmission to iOS
  /// 3. Sending the configuration to native iOS code
  /// 4. Setting up the permission request UI components using iOS frameworks
  /// 5. Configuring behavior flags (auto-dismiss, auto-check, etc.)
  /// 6. Preparing iOS-specific permission handlers for each permission type
  ///
  /// Parameters:
  /// - [config]: A FlutterPermissionKitConfig instance containing:
  ///   - List of permissions to request (with iOS Info.plist requirements)
  ///   - UI customization options (colors, text, display type)
  ///   - Behavior settings (auto-dismiss, auto-check)
  ///
  /// Returns:
  // ignore: unintended_html_in_doc_comment
  /// - A Future<bool> that resolves to:
  ///   - `true` if iOS initialization was successful
  ///   - `false` if initialization failed (invalid config, iOS platform error, etc.)
  ///
  /// Throws:
  /// - May throw iOS-specific exceptions if the native code encounters
  ///   critical errors during initialization
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   final config = FlutterPermissionKitConfig(
  ///     displayType: DisplayType.modal,
  ///     displayTitle: 'Permission Request',
  ///     displayHeaderDescription: 'To provide key features, we need access to:',
  ///     displayBottomDescription: 'You can change these settings later in app preferences.',
  ///     permissions: [
  ///       Permission(
  ///         name: 'Camera',
  ///         description: 'Take photos and videos',
  ///         type: PermissionType.camera,
  ///       ),
  ///       Permission(
  ///         name: 'Photo Library',
  ///         description: 'Access your photo collection',
  ///         type: PermissionType.photos,
  ///       ),
  ///     ],
  ///   );
  ///
  ///   final success = await FlutterPermissionKit.init(config: config);
  ///
  ///   if (success) {
  ///     print('Permission kit ready to use');
  ///     // Now you can proceed with permission requests
  ///   } else {
  ///     print('Failed to initialize permission kit');
  ///     // Handle initialization failure
  ///   }
  /// } catch (e) {
  ///   print('Error during permission kit initialization: $e');
  ///   // Handle exceptions
  /// }
  /// ```
  ///
  /// Important notes:
  /// - This method should be called only once during app initialization
  /// - Subsequent calls will override the previous configuration
  /// - Ensure all required permissions are included in the configuration
  /// - Ensure proper iOS Info.plist usage descriptions are configured
  /// - The configuration cannot be modified after initialization without
  ///   calling init() again with a new configuration
  static Future<bool> init({required FlutterPermissionKitConfig config}) async {
    final res = await FlutterPermissionKitChannel.init(config);
    return res;
  }

  /// Request a permission without any UI.
  ///
  /// This method is used to request a permission without any UI. It is used
  /// to request a permission that does not require any UI.
  ///
  /// Parameters:
  /// - [permission]: The permission to request
  static Future<AuthorizationStatus> request(PermissionType permission) async {
    final res = await FlutterPermissionKitChannel.request(permission);
    return res;
  }
}
