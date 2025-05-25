import 'package:flutter/services.dart';
import 'package:flutter_permission_kit/core/flutter_permission_kit_config.dart';

/// Platform channel communication handler for Flutter Permission Kit
///
/// This class serves as the bridge between the Flutter Dart code and the
/// native platform implementations (iOS). It handles all
/// communication through Flutter's MethodChannel system, allowing the
/// Flutter app to invoke native permission handling code.
///
/// The class follows the singleton pattern with static methods, ensuring
/// a single point of communication with the native platforms. This design
/// prevents multiple channel instances and potential conflicts.
///
/// Key responsibilities:
/// - Establishing communication channel with native code
/// - Serializing configuration data for platform transmission
/// - Invoking native permission handling methods
/// - Managing the lifecycle of permission requests
///
/// Example usage:
/// ```dart
/// final config = FlutterPermissionKitConfig(
///   permissions: [Permission(type: PermissionType.camera)],
/// );
/// await FlutterPermissionKitChannel.init(config);
/// ```
class FlutterPermissionKitChannel {
  /// The method channel used for communication with native platform code
  ///
  /// This channel uses the identifier 'flutter_permission_kit' to establish
  /// a communication bridge between Flutter and the native iOS/Android code.
  /// The channel name must match exactly with the native implementation
  /// to ensure proper message routing.
  ///
  /// The channel is declared as static and const to ensure:
  /// - Single instance across the entire application lifecycle
  /// - Immutable reference preventing accidental modification
  /// - Efficient memory usage without repeated instantiation
  static const MethodChannel _channel = MethodChannel('flutter_permission_kit');

  /// Initializes the permission kit with the provided configuration
  ///
  /// This method sends the complete permission configuration to the native
  /// platform code, triggering the initialization of the permission handling
  /// system. The configuration is serialized to JSON format before transmission
  /// to ensure compatibility across the platform boundary.
  ///
  /// The initialization process on the native side typically involves:
  /// - Parsing the configuration data
  /// - Setting up UI components with custom styling
  /// - Preparing permission request handlers
  /// - Configuring behavior flags (auto-dismiss, auto-check, etc.)
  ///
  /// Parameters:
  /// - [config]: A FlutterPermissionKitConfig instance containing all
  ///   permission settings, UI customization options, and behavior flags
  ///
  /// Returns:
  /// - A Future<void> that completes when the native initialization is finished
  ///
  /// Throws:
  /// - PlatformException: If the native platform encounters an error during
  ///   initialization, such as invalid configuration data or platform-specific
  ///   setup failures
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
  ///     primaryColor: Colors.blue,
  ///   );
  ///
  ///   await FlutterPermissionKitChannel.init(config);
  ///   print('Permission kit initialized successfully');
  /// } catch (e) {
  ///   print('Failed to initialize permission kit: $e');
  /// }
  /// ```
  ///
  /// Note: This method should be called before attempting to request any
  /// permissions through the kit. Multiple calls to init() will override
  /// the previous configuration.
  static Future<bool> init(FlutterPermissionKitConfig config) async {
    final res = await _channel.invokeMethod('init', config.toJson());
    return res;
  }
}
