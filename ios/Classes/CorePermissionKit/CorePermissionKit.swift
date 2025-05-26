//
//  CorePermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Flutter
import Foundation

class CorePermissionKit {
    static let share = CorePermissionKit()
    
    private var config: FlutterPermissionKitConfig?
    
    func initPermissionKit(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let config = FlutterPermissionKitConfig(from: args) else {
            result(false)
            return
        }
        
        self.config = config
        
        result(true)
    }
}
