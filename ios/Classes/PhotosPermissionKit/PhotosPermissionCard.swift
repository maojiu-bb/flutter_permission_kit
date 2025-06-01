//
//  PhotosPermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/30.
//

import SwiftUI

@available(iOS 15.0, *)
struct PhotosPermissionCard: View {
    @StateObject private var photosPermissionKit = PhotosPermissionKit()
    private var corePermissionKit = CorePermissionKit()
    
    var title: String?
    var description: String?
    // Callback to notify when all permissions are determined
    var onPermissionsCompleted: (() -> Void)?
    
    // Custom initializer to accept parameters
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    var body: some View {
        return CorePermissionCard(
            icon: "photo",
            title: title ?? "Photo Library",
            description: description ?? "Allow to access your photos",
            status: photosPermissionKit.permissionStatus
        ) {
            photosPermissionKit.requestPermission()
        }
        .onChange(of: photosPermissionKit.status) { newStatus in
            // Monitor permission status changes
            if newStatus != .notDetermined {
                // Check if all permissions are determined after this permission changed
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    let statusMap = corePermissionKit.checkPermissionsStatus()
                    if !statusMap.values.contains(.notDetermined) {
                        onPermissionsCompleted?()
                    }
                }
            }
        }
    }
}
