
import 'flutter_permission_kit_platform_interface.dart';

class FlutterPermissionKit {
  Future<String?> getPlatformVersion() {
    return FlutterPermissionKitPlatform.instance.getPlatformVersion();
  }
}
