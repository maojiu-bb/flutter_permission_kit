//
//  SpeechPermissionCard.swift
//  flutter_permission_kit
//
//  Created by 钟钰 on 2025/6/2.
//


import SwiftUI

@available(iOS 15.0, *)
struct SpeechPermissionCard: View {
    private let corePermissionKit = CorePermissionKit.share
    
    var title: String?
    
    var description: String?
    
    var onPermissionsCompleted: (() -> Void)?
    
    private var speechPermissionKit: SpeechPermissionKit? {
        return PermissionKitManager.shared.getKit(for: .speech) as? SpeechPermissionKit
    }
    
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    var body: some View {
        Group {
            if let kit = speechPermissionKit {
                CorePermissionCard<SpeechPermissionKit>(
                    icon: "waveform.circle",
                    title: title ?? "Speech",
                    description: description ?? "Allow to access your speech",
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
                Text("Speech permission kit not available")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
}
