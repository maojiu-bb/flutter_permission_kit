//
//  SpeechPermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import SwiftUI

/// SwiftUI view card for speech recognition permission request interface
/// Displays a user-friendly interface for requesting speech recognition access
@available(iOS 15.0, *)
struct SpeechPermissionCard: View {
    /// Core permission kit shared instance
    private let corePermissionKit = CorePermissionKit.share
    
    /// Custom title for the permission card
    var title: String?
    
    /// Custom description for the permission request
    var description: String?
    
    /// Completion callback when permission flow finishes
    var onPermissionsCompleted: (() -> Void)?
    
    /// Gets the speech permission kit from the manager
    private var speechPermissionKit: SpeechPermissionKit? {
        return PermissionKitManager.shared.getKit(for: .speech) as? SpeechPermissionKit
    }
    
    /// Initializes the permission card with optional customization
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    var body: some View {
        Group {
            if let kit = speechPermissionKit {
                // Create the permission card UI with waveform icon
                CorePermissionCard<SpeechPermissionKit>(
                    icon: "waveform.circle",
                    title: title ?? "Speech",
                    description: description ?? "Allow to access your speech",
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
                Text("Speech permission kit not available")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
}
