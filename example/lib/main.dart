import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_permission_kit/core/flutter_permission_kit_config.dart';
import 'package:flutter_permission_kit/core/permission.dart';
import 'package:flutter_permission_kit/enums/authoricate_status.dart';
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
      if (Platform.isIOS) {
        if (!mounted) return;
        final res = await FlutterPermissionKit.init(
          config: FlutterPermissionKitConfig(
            displayType: DisplayType.alert,
            displayTitle: 'Permission Request',
            displayHeaderDescription:
                'In order to use this app, we need to access your permissions',
            displayBottomDescription:
                'We need your permissions to show you the best results',
            permissions: [
              Permission(
                name: 'Photo Library',
                description: 'Access to your photos',
                type: PermissionType.photos,
              ),
              Permission(
                name: 'Camera',
                description: 'Access to your camera',
                type: PermissionType.camera,
              ),
              Permission(
                name: 'Microphone',
                description: 'Access to your microphone',
                type: PermissionType.microphone,
              ),
              Permission(
                name: 'Speech',
                description: 'Access to your speech',
                type: PermissionType.speech,
              ),
              Permission(
                name: 'Contracts',
                description: 'Access to your contracts',
                type: PermissionType.contacts,
              ),
              Permission(
                name: 'Notification',
                description: 'Access to your notifications',
                type: PermissionType.notification,
              ),
              Permission(
                name: 'Location',
                description: 'Access to your location',
                type: PermissionType.location,
              ),
              Permission(
                name: 'Calendar',
                description: 'Access to your calendar',
                type: PermissionType.calendar,
              ),
              Permission(
                name: 'Tracking',
                description: 'Access to your tracking',
                type: PermissionType.tracking,
              ),
              Permission(
                name: 'Reminder',
                description: 'Access to your reminder',
                type: PermissionType.reminder,
              ),
              Permission(
                name: 'Bluetooth',
                description: 'Access to your bluetooth',
                type: PermissionType.bluetooth,
              ),
              Permission(
                name: 'Apple Music',
                description: 'Access to your Apple Music',
                type: PermissionType.music,
              ),
              Permission(
                name: 'Siri',
                description: 'Access to your Siri',
                type: PermissionType.siri,
              ),
              Permission(
                name: 'Health Data',
                description: 'Access to your health data',
                type: PermissionType.health,
              ),
              // Permission(
              //   name: 'Motion & Fitness',
              //   description: 'Access to your motion and fitness data',
              //   type: PermissionType.motion,
              // ),
            ],
          ),
        );
        debugPrint("[FlutterPermissionKit.init: $res]");
      }
    });
  }

  AuthorizationStatus motionPermissionStatus =
      AuthorizationStatus.notDetermined;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            children: [
              Text('Running on: ios\n'),
              SizedBox(height: 10),
              Text(
                "Motion & Fitness Permission: ${motionPermissionStatus.name}",
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final status = await FlutterPermissionKit.request(
                    PermissionType.motion,
                  );
                  debugPrint("[FlutterPermissionKit.request: $status]");
                  setState(() {
                    motionPermissionStatus = status;
                  });
                },
                child: Text("Request Motion & Fitness Permission"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
