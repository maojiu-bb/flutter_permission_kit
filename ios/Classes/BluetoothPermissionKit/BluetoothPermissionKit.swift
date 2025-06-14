//
//  BluetoothPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import Foundation
import SwiftUI
import CoreBluetooth

@available(iOS 15.0, *)
class BluetoothPermissionKit: NSObject, ObservableObject, PermissionKitProtocol, CBCentralManagerDelegate {
    @Published var status: CBManagerAuthorization = CBManagerAuthorization.notDetermined
    
    var permissionType: PermissionType {
        return .bluetooth
    }
    
    private var centralManager: CBCentralManager?
    
    override init() {
        super.init()
        self.status = CBCentralManager.authorization
    }
    
    func requestPermission(completion: ( (AuthorizationStatus) -> Void)? = nil) {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        completion?(self.permissionStatus)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        DispatchQueue.main.async {
            self.status = CBCentralManager.authorization
        }
    }
    
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .allowedAlways:
            return .granted
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            // Handle any future unknown authorization status cases
            return .notDetermined
        }
    }
    
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView {
        return AnyView(
            BluetoothPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
