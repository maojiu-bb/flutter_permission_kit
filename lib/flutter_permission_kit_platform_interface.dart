import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_permission_kit_method_channel.dart';

abstract class FlutterPermissionKitPlatform extends PlatformInterface {
  /// Constructs a FlutterPermissionKitPlatform.
  FlutterPermissionKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPermissionKitPlatform _instance = MethodChannelFlutterPermissionKit();

  /// The default instance of [FlutterPermissionKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPermissionKit].
  static FlutterPermissionKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPermissionKitPlatform] when
  /// they register themselves.
  static set instance(FlutterPermissionKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
