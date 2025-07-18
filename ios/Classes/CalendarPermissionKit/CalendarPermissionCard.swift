//
//  CalendarPermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//


import SwiftUI

/// SwiftUI view card for calendar permission request interface
/// Displays a user-friendly interface for requesting calendar access
@available(iOS 15.0, *)
struct CalendarPermissionCard: View {
    /// Core permission kit shared instance
    private let corePermissionKit = CorePermissionKit.share
    
    /// Custom title for the permission card
    var title: String?
    
    /// Custom description for the permission request
    var description: String?
    
    /// Completion callback when permission flow finishes
    var onPermissionsCompleted: (() -> Void)?
    
    /// Gets the calendar permission kit from the manager
    private var calendarPermissionKit: CalendarPermissionKit? {
        return PermissionKitManager.shared.getKit(for: .calendar) as? CalendarPermissionKit
    }
    
    /// Initializes the permission card with optional customization
    init(title: String? = nil, description: String? = nil, onPermissionsCompleted: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.onPermissionsCompleted = onPermissionsCompleted
    }
    
    var body: some View {
        Group {
            if let kit = calendarPermissionKit {
                // Create the permission card UI with calendar icon
                CorePermissionCard<CalendarPermissionKit>(
                    icon: "calendar",
                    title: title ?? "Calendar",
                    description: description ?? "Allow to access your calendar",
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
                Text("Calendar permission kit not available")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }
}

