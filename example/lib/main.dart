import 'package:flutter/material.dart';
import 'package:flutter_permission_kit/core/flutter_permission_kit_config.dart';
import 'package:flutter_permission_kit/core/permission.dart';
import 'package:flutter_permission_kit/enums/display_type.dart';
import 'package:flutter_permission_kit/enums/permission_type.dart';
import 'package:flutter_permission_kit/flutter_permission_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final res = await FlutterPermissionKit.init(
        config: FlutterPermissionKitConfig(
          displayType: DisplayType.alert,
          displayTitle: 'Permission Request',
          displayHeaderDescription:
              'We need your location to show you the best results',
          displayBottomDescription:
              'We need your location to show you the best results',
          primaryColor: Colors.blue,
          permissions: [
            Permission(
              name: 'photos',
              description: 'Photos permission',
              type: PermissionType.photos,
            ),
          ],
        ),
      );
      debugPrint("[FlutterPermissionKit.init: $res]");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Running on: ios\n')),
      ),
    );
  }
}
