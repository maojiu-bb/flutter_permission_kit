import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_permission_kit/flutter_permission_kit.dart';
import 'package:flutter_permission_kit/flutter_permission_kit_platform_interface.dart';
import 'package:flutter_permission_kit/flutter_permission_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPermissionKitPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPermissionKitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPermissionKitPlatform initialPlatform = FlutterPermissionKitPlatform.instance;

  test('$MethodChannelFlutterPermissionKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPermissionKit>());
  });

  test('getPlatformVersion', () async {
    FlutterPermissionKit flutterPermissionKitPlugin = FlutterPermissionKit();
    MockFlutterPermissionKitPlatform fakePlatform = MockFlutterPermissionKitPlatform();
    FlutterPermissionKitPlatform.instance = fakePlatform;

    expect(await flutterPermissionKitPlugin.getPlatformVersion(), '42');
  });
}
