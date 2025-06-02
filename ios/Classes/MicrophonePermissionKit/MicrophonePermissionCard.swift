//
//  MicrophonePermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import SwiftUI

/// SwiftUI view card for microphone permission request interface
/// Displays a user-friendly interface for requesting microphone access
@available(iOS 15.0, *)
struct MicrophonePermissionCard: View {
    /// Core permission kit shared instance
    private let corePermissionKit = CorePermissionKit.share
    
    /// Custom title for the permission card
    var title: String?
    
    /// Custom description for the permission request
    var description: String?
    
    /// Completion callback when permission flow finishes
    var onPermissionsCompleted: (() -> Void)?
    
    /// Gets the microphone permission kit from the manager
    private var microphonePermissionKit: MicrophonePermissionKit? {
        return PermissionKitManager.shared.getKit(for: .microphone) as? MicrophonePermissionKit
    }
    
    /// Initializes the permission card with optional customization
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    var body: some View {
        Group {
            if let kit = microphonePermissionKit {
                // Create the permission card UI with microphone icon
                CorePermissionCard<MicrophonePermissionKit>(
                    icon: "microphone.circle",
                    title: title ?? "Microphone",
                    description: description ?? "Allow to access your microphone",
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
                Text("Microphone permission kit not available")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
}

