//
//  CorePermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/28.
//

import SwiftUI
import Combine

/**
 * CorePermissionCard
 * 
 * A generic, reusable SwiftUI component that provides the base UI for all permission request cards
 * in the Flutter Permission Kit system. This component uses Swift generics to work with any
 * permission kit type while maintaining type safety and consistent visual design.
 * 
 * **Generic Design Benefits**:
 * - **Type Safety**: Generic constraint ensures only valid permission kits are used
 * - **Code Reuse**: Single implementation serves all permission types
 * - **Consistency**: Uniform visual appearance across all permission cards
 * - **Maintainability**: Changes to card design affect all permission types automatically
 * - **Performance**: SwiftUI can optimize generic views efficiently
 * 
 * **Architecture Role**:
 * - **Base Component**: Foundation for all specific permission card implementations
 * - **UI Standardization**: Ensures consistent visual language across permission types
 * - **State Management**: Handles permission status observation and UI updates
 * - **Interaction Handling**: Manages button taps and user interactions
 * 
 * **Visual Design**:
 * - Icon + Title + Description + Action Button layout
 * - Dynamic button styling based on permission status
 * - Responsive design that adapts to content length
 * - iOS design system compliance (SF Symbols, system colors, typography)
 * 
 * **Usage Pattern**:
 * ```swift
 * CorePermissionCard<CameraPermissionKit>(
 *     icon: "camera",
 *     title: "Camera",
 *     description: "Take photos and videos",
 *     permissionKit: cameraKit
 * ) {
 *     cameraKit.requestPermission()
 * }
 * ```
 * 
 * Requirements: iOS 15.0 or later for SwiftUI features and protocol requirements
 */
@available(iOS 15.0, *)
struct CorePermissionCard<PermissionKit: PermissionKitProtocol>: View {
    
    /**
     * SF Symbol icon name for the permission type
     * 
     * The system icon that visually represents the permission being requested.
     * Uses Apple's SF Symbols for consistent, high-quality iconography that
     * automatically adapts to user settings (accessibility, dark mode, etc.).
     * 
     * **Design Guidelines**:
     * - Should clearly represent the permission functionality
     * - Must be a valid SF Symbol name available in target iOS versions
     * - Prefer outlined style icons for better visibility
     * 
     * **Examples**: "camera", "photo", "location", "microphone"
     */
    var icon: String
    
    /**
     * Display title for the permission card
     * 
     * The primary text that identifies what permission is being requested.
     * This is typically a short, user-friendly name that clearly communicates
     * the functionality enabled by granting the permission.
     * 
     * **Content Guidelines**:
     * - Keep concise (1-3 words ideal)
     * - Use title case capitalization
     * - Be specific about the feature/capability
     * 
     * **Examples**: "Camera", "Photo Library", "Location Services"
     */
    var title: String
    
    /**
     * Descriptive text explaining the permission purpose
     * 
     * Secondary text that provides context about why the app needs this permission
     * and how it will be used. This is crucial for user trust and improving
     * permission grant rates by setting clear expectations.
     * 
     * **Content Guidelines**:
     * - Explain the specific benefit to the user
     * - Be honest about data usage
     * - Keep to 1-2 sentences for readability
     * - Use friendly, non-technical language
     * 
     * **Examples**: 
     * - "Take photos and record videos for your posts"
     * - "Access your photos to share and edit images"
     */
    var description: String
    
    /**
     * The permission kit instance that manages this permission type
     * 
     * This generic property holds a reference to the specific permission kit
     * (CameraPermissionKit, PhotosPermissionKit, etc.) that handles the business logic
     * for this permission type. The @ObservedObject property wrapper enables
     * automatic UI updates when the permission status changes.
     * 
     * **Key Features**:
     * - **Reactive Updates**: UI automatically reflects permission status changes
     * - **Type Safety**: Generic constraint ensures correct kit type
     * - **State Synchronization**: Single source of truth for permission state
     * - **Lifecycle Management**: SwiftUI manages observation lifecycle automatically
     */
    @ObservedObject var permissionKit: PermissionKit
    
    /**
     * Callback closure executed when the permission card is tapped
     * 
     * This closure defines the action to take when the user taps the permission
     * button. Typically, this triggers a permission request, but the flexibility
     * allows for custom behavior (analytics, navigation, etc.) before or after
     * the actual permission request.
     * 
     * **Common Implementations**:
     * - Direct permission request: `{ kit.requestPermission() }`
     * - Analytics + request: `{ analytics.track("permission_requested"); kit.requestPermission() }`
     * - Conditional logic: `{ if shouldRequest { kit.requestPermission() } }`
     */
    var onTap: () -> Void
    
    /**
     * Computed text for the action button based on current permission status
     * 
     * This computed property dynamically determines the appropriate button text
     * based on the permission's current authorization status. The text changes
     * to provide clear feedback about the permission state and expected actions.
     * 
     * **Status Mapping**:
     * - `.notDetermined` → "Allow": Indicates user can grant permission
     * - `.limited` → "Limited": Shows partial access granted (iOS 14+ Photos)
     * - `.granted` → "Allowed": Confirms full permission granted
     * - `.denied` → "Denied": Indicates user has denied permission
     * 
     * **UI Behavior**: Text updates automatically when permission status changes
     * **Accessibility**: Provides clear state information for screen readers
     */
    var buttonText: String {
        switch permissionKit.permissionStatus {
        case .notDetermined:
            return "Allow"
        case .limited:
            return "Limited"
        case .granted:
            return "Allowed"
        case .denied:
            return "Denied"
        }
    }
    
    /**
     * Computed color for the action button text based on permission status
     * 
     * This computed property determines the appropriate text color for the action
     * button to provide visual feedback about the permission state and interaction
     * availability. Colors follow iOS design guidelines for semantic meaning.
     * 
     * **Color Mapping**:
     * - `.granted/.denied/.limited` → Gray: Indicates no action needed/possible
     * - `.notDetermined` → Blue: Indicates actionable state (system accent color)
     * 
     * **Design Rationale**:
     * - Blue: System accent color indicating interactive, actionable element
     * - Gray: Subdued color indicating informational, non-interactive state
     * 
     * **Accessibility**: Colors work with system accessibility settings and high contrast modes
     */
    var buttonForegroundStyle: Color {
        switch permissionKit.permissionStatus {
        case .granted, .denied, .limited:
                .gray
        case .notDetermined:
                .blue
        }
    }
    
    /**
     * SwiftUI view body defining the card's visual layout and structure
     * 
     * This computed property defines the complete visual hierarchy and layout
     * of the permission card using SwiftUI's declarative syntax. The layout
     * uses a horizontal stack with consistent spacing and alignment.
     * 
     * **Layout Structure**:
     * ```
     * HStack {
     *   Icon (28x28 pt)
     *   VStack {
     *     Title (headline, bold)
     *     Description (footnote, gray)
     *   }
     *   Spacer
     *   Button {
     *     Status Text (caption, styled)
     *   }
     * }
     * ```
     * 
     * **Design Features**:
     * - **Icon**: Fixed 28pt size with blue accent color for visual consistency
     * - **Text Stack**: Left-aligned title and description with appropriate typography
     * - **Flexible Layout**: Spacer pushes button to trailing edge
     * - **Interactive Button**: Styled with rounded background and dynamic colors
     * - **Responsive**: Adapts to different screen sizes and content lengths
     * 
     * **Accessibility**: Automatically supports Dynamic Type, VoiceOver, and other accessibility features
     */
    var body: some View {
        HStack(spacing: 12) {
            // Permission type icon using SF Symbols
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28)
                .foregroundStyle(.blue)
            
            // Text content stack with title and description
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline.bold())
                
                Text(description)
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            
            // Push button to trailing edge
            Spacer()
            
            // Action button with dynamic styling
            Button {
                onTap()
            } label: {
                Text(buttonText)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .foregroundStyle(buttonForegroundStyle)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 30,
                            style: .continuous
                        )
                        .fill(
                            Color(
                                UIColor.secondarySystemBackground
                            )
                        )
                    )
            }
        }
    }
}
