//
//  LocationPermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//


import SwiftUI

@available(iOS 15.0, *)
struct LocationPermissionCard: View {
    private let corePermissionKit = CorePermissionKit.share
    
    var title: String?
    
    var description: String?
    
    var onPermissionsCompleted: (() -> Void)?
    
    private var locationPermissionKit: LocationPermissionKit? {
        return PermissionKitManager.shared.getKit(for: .location) as? LocationPermissionKit
    }
    
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    var body: some View {
        Group {
            if let kit = locationPermissionKit {
                CorePermissionCard<LocationPermissionKit>(
                    icon: "location.app",
                    title: title ?? "Location",
                    description: description ?? "Allow to access your location",
                    permissionKit: kit
                ) {
                    kit.requestPermission()
                }
                .onReceive(kit.$status) { newStatus in
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
                Text("Location permission kit not available")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
}


