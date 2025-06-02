//
//  BluetoothPermissionView.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//


import SwiftUI

@available(iOS 15.0, *)
struct BluetoothPermissionCard: View {
    private let corePermissionKit = CorePermissionKit.share
    
    var title: String?
    
    var description: String?
    
    var onPermissionsCompleted: (() -> Void)?
    
    private var bluetoothPermissionKit: BluetoothPermissionKit? {
        return PermissionKitManager.shared.getKit(for: .bluetooth) as? BluetoothPermissionKit
    }
    
    /// Initializes the permission card with optional customization
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    var body: some View {
        Group {
            if let kit = bluetoothPermissionKit {
                // Create the permission card UI with reminder icon
                CorePermissionCard<BluetoothPermissionKit>(
                    icon: "antenna.radiowaves.left.and.right",
                    title: title ?? "Bluetooth",
                    description: description ?? "Allow to access your Bluetooth",
                    permissionKit: kit
                ) {
                    kit.requestPermission()
                }
                .onReceive(kit.$status) { newStatus in
                    // Monitor status changes and complete flow when no undetermined permissions remain
                    if newStatus != .notDetermined {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            let statusMap = corePermissionKit.checkPermissionsStatus()
                            
                            let hasUndetermined = statusMap.values.contains(.notDetermined)
                            
                            if !hasUndetermined {
                                onPermissionsCompleted?()
                            }
                        }
                    }
                }
            } else {
                // Fallback UI when permission kit is not available
                Text("Bluetooth permission kit not available")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
}


