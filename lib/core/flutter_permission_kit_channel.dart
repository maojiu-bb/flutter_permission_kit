import 'package:flutter/services.dart';
import 'package:flutter_permission_kit/core/flutter_permission_kit_config.dart';

/// Platform channel communication handler for Flutter Permission Kit
///
/// This class serves as the bridge between the Flutter Dart code and the
/// native iOS implementation. It handles all communication through Flutter's
/// MethodChannel system, allowing the Flutter app to invoke native iOS
/// permission handling code using iOS frameworks.
///
/// The class follows the singleton pattern with static methods, ensuring
/// a single point of communication with the iOS platform. This design
/// prevents multiple channel instances and potential conflicts.
///
/// Key responsibilities:
/// - Establishing communication channel with native iOS code
/// - Serializing configuration data for iOS platform transmission
/// - Invoking native iOS permission handling methods
/// - Managing the lifecycle of iOS permission requests
/// - Handling iOS-specific permission responses and status updates
///
/// Example usage:
/// ```dart
/// final config = FlutterPermissionKitConfig(
///   permissions: [Permission(type: PermissionType.camera)],
/// );
/// await FlutterPermissionKitChannel.init(config);
/// ```
class FlutterPermissionKitChannel {
  /// The method channel used for communication with native iOS platform code
  ///
  /// This channel uses the identifier 'flutter_permission_kit' to establish
  /// a communication bridge between Flutter and the native iOS code.
  /// The channel name must match exactly with the iOS implementation
  /// to ensure proper message routing.
  ///
  /// The channel is declared as static and const to ensure:
  /// - Single instance across the entire application lifecycle
  /// - Immutable reference preventing accidental modification
  /// - Efficient memory usage without repeated instantiation
  static const MethodChannel _channel = MethodChannel('flutter_permission_kit');

  /// Initializes the permission kit with the provided configuration for iOS
  ///
  /// This method sends the complete permission configuration to the native
  /// iOS platform code, triggering the initialization of the iOS permission
  /// handling system using appropriate iOS frameworks (AVFoundation, Photos,
  /// UserNotifications, etc.). The configuration is serialized to JSON format
  /// before transmission to ensure compatibility across the platform boundary.
  ///
  /// The initialization process on the iOS side typically involves:
  /// - Parsing the configuration data
  /// - Setting up SwiftUI components with custom styling
  /// - Preparing iOS permission request handlers for each permission type
  /// - Configuring iOS-specific behavior flags (auto-dismiss, auto-check, etc.)
  /// - Validating Info.plist usage descriptions are present
  ///
  /// Parameters:
  /// - [config]: A FlutterPermissionKitConfig instance containing all
  ///   permission settings, UI customization options, and behavior flags
  ///   specifically designed for iOS implementation
  ///
  /// Returns:
  /// - A Future<bool> that completes when the native iOS initialization is finished
  ///   - `true` if iOS initialization was successful
  ///   - `false` if iOS initialization failed
  ///
  /// Throws:
  /// - PlatformException: If the native iOS platform encounters an error during
  ///   initialization, such as invalid configuration data, missing Info.plist
  ///   entries, or iOS framework-specific setup failures
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   final config = FlutterPermissionKitConfig(
  ///     permissions: [
  ///       Permission(
  ///         name: 'Camera Access',
  ///         description: 'Take photos and videos',
  ///         type: PermissionType.camera,
  ///       ),
  ///     ],
  ///     displayTitle: 'App Permissions',
  ///   );
  ///
  ///   final success = await FlutterPermissionKitChannel.init(config);
  ///   if (success) {
  ///     print('iOS permission kit initialized successfully');
  ///   } else {
  ///     print('Failed to initialize iOS permission kit');
  ///   }
  /// } catch (e) {
  ///   print('Failed to initialize iOS permission kit: $e');
  /// }
  /// ```
  ///
  /// Note: This method should be called before attempting to request any
  /// permissions through the kit. Multiple calls to init() will override
  /// the previous configuration with new iOS settings.
  static Future<bool> init(FlutterPermissionKitConfig config) async {
    final res = await _channel.invokeMethod('init', config.toJson());
    return res;
  }
}
