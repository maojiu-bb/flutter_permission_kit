//
//  CorePermissionView.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/26.
//

import SwiftUI

/**
 * CorePermissionView
 * 
 * The main SwiftUI view component that serves as the container for the entire permission
 * request interface in the Flutter Permission Kit system. This generic view component
 * provides a structured layout for displaying permission requests with customizable
 * content and consistent visual design.
 * 
 * **Architecture Role**:
 * - **Main Container**: Top-level view that houses all permission request UI
 * - **Layout Manager**: Provides structured layout with header, content, and footer sections
 * - **Content Host**: Accepts generic content allowing flexible permission card arrangements
 * - **Design System**: Implements consistent visual design language across all permission flows
 * 
 * **Generic Design Benefits**:
 * - **Flexibility**: Accepts any SwiftUI content type through generic Content parameter
 * - **Reusability**: Same container works for single or multiple permission requests
 * - **Type Safety**: Swift generics ensure content type safety at compile time
 * - **Performance**: SwiftUI optimizes generic views efficiently
 * 
 * **Visual Structure**:
 * ```
 * ┌─────────────────────────────────────┐
 * │ Display Title (Large, Bold)         │
 * │                                     │
 * │ Header Description (Body text)      │
 * │                                     │
 * │ ┌─────────────────────────────────┐ │
 * │ │                                 │ │
 * │ │ Permission Cards Content        │ │
 * │ │ (Generic Content)               │ │
 * │ │                                 │ │
 * │ └─────────────────────────────────┘ │
 * │                                     │
 * │ Bottom Description (Body text)      │
 * └─────────────────────────────────────┘
 * ```
 * 
 * **Usage Pattern**:
 * ```swift
 * CorePermissionView(
 *     displayTitle: "Grant Permissions",
 *     displayHeaderDescription: "To provide the best experience...",
 *     displayBottomDescription: "You can change these anytime..."
 * ) {
 *     // Permission cards content
 *     CameraPermissionCard(...)
 *     PhotosPermissionCard(...)
 * }
 * ```
 * 
 * Requirements: iOS 15.0 or later for SwiftUI features and design system elements
 */
@available(iOS 15.0, *)
struct CorePermissionView<Content: View>: View {
    
    /**
     * The main title displayed at the top of the permission interface
     * 
     * This is the primary heading that introduces the permission request flow.
     * It should be clear, concise, and immediately communicate that the app
     * is requesting permissions from the user.
     * 
     * **Design Guidelines**:
     * - Keep concise (2-4 words ideal)
     * - Use action-oriented language
     * - Maintain consistent tone with app branding
     * - Consider localization for international audiences
     * 
     * **Typography**: Displayed using iOS title font style with bold weight
     * **Examples**: "Grant Permissions", "App Setup", "Enable Features"
     */
    let displayTitle: String
    
    /**
     * Explanatory text shown below the main title
     * 
     * This description provides context for the permission requests and helps
     * users understand why the app needs these permissions. It appears in the
     * header section before the permission cards are displayed.
     * 
     * **Content Guidelines**:
     * - Explain the overall benefit to the user
     * - Be transparent about how permissions will be used
     * - Keep to 1-2 sentences for optimal readability
     * - Use friendly, accessible language
     * 
     * **Typography**: Displayed using iOS callout font style with secondary color
     * **Example**: "To provide the best experience, this app needs access to the following features."
     */
    let displayHeaderDescription: String
    
    /**
     * Additional text shown below the permission cards
     * 
     * This description appears at the bottom of the interface and typically
     * provides reassurance, additional context, or information about how
     * users can modify permissions later.
     * 
     * **Common Use Cases**:
     * - Privacy reassurances ("Your data stays private")
     * - Settings instructions ("You can change these in Settings")
     * - Additional context about permission usage
     * - Legal or policy information (brief)
     * 
     * **Typography**: Displayed using iOS callout font style with secondary color
     * **Example**: "You can modify these permissions anytime in Settings > Privacy."
     */
    let displayBottomDescription: String
    
    /**
     * Generic content builder that provides the permission cards
     * 
     * This closure-based content builder allows the view to accept any SwiftUI
     * content while maintaining type safety. The content typically consists of
     * permission cards but can include any SwiftUI views.
     * 
     * **Generic Benefits**:
     * - **Flexibility**: Can contain any combination of permission cards
     * - **Composition**: Enables building complex permission flows
     * - **Type Safety**: SwiftUI ensures content type correctness
     * - **Performance**: SwiftUI optimizes generic content efficiently
     * 
     * **Typical Content**: Multiple permission cards (CameraPermissionCard, PhotosPermissionCard, etc.)
     */
    let content: () -> Content
    
    /**
     * Initializes the CorePermissionView with configuration and content
     * 
     * This initializer accepts all the text configuration for the permission interface
     * along with a content builder that provides the permission cards or other UI elements.
     * 
     * - Parameters:
     *   - displayTitle: Main heading text for the permission interface
     *   - displayHeaderDescription: Explanatory text shown below the title
     *   - displayBottomDescription: Additional text shown below permission cards
     *   - content: ViewBuilder closure that provides the permission cards content
     * 
     * **ViewBuilder**: The content parameter uses SwiftUI's @ViewBuilder attribute,
     * enabling natural SwiftUI syntax for building multiple views.
     */
    init(
        displayTitle: String,
        displayHeaderDescription: String,
        displayBottomDescription: String,
        content: @escaping () -> Content
    ) {
        self.displayTitle = displayTitle
        self.displayHeaderDescription = displayHeaderDescription
        self.displayBottomDescription = displayBottomDescription
        self.content = content
    }
    
    /**
     * SwiftUI view body defining the complete interface layout
     * 
     * This computed property defines the visual hierarchy and layout structure
     * for the entire permission request interface. The layout uses a vertical
     * stack with carefully designed spacing, typography, and visual effects.
     * 
     * **Layout Architecture**:
     * ```
     * VStack(alignment: .leading) {
     *   Title (Primary color, title font, bold)
     *   Header Description (Secondary color, callout font)
     *   Content Container {
     *     Permission Cards (Generic content)
     *   } with background + shadow
     *   Bottom Description (Secondary color, callout font)
     * } with padding + background
     * ```
     * 
     * **Design Features**:
     * - **Structured Layout**: Clear hierarchy with title, content, and footer
     * - **Consistent Spacing**: Carefully tuned spacing for optimal readability
     * - **Visual Depth**: Shadow and background create card-like container effect
     * - **System Integration**: Uses iOS system colors and typography for native feel
     * - **Responsive Design**: Adapts to different screen sizes and orientations
     * - **Accessibility**: Supports Dynamic Type, VoiceOver, and other accessibility features
     * 
     * **Visual Effects**:
     * - Rounded corners with continuous corner style for modern appearance
     * - Subtle shadow for depth and visual separation
     * - Secondary background color for content container
     * - System background colors that adapt to light/dark mode
     */
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Content container
                    VStack(alignment: .leading) {
                        // Main title with prominent typography
                        Text(displayTitle)
                            .font(.title.bold())
                            .foregroundStyle(.primary)
                            .padding(.bottom)
                        
                        // Header description with secondary styling
                        Text(displayHeaderDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        
                        // Permission cards container with visual styling
                        VStack {
                            content()
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                            .fill(.background)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.vertical)
                        
                        // Bottom description with secondary styling
                        Text(displayBottomDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 30,
                            style: .continuous
                        )
                        .fill(Color(.secondarySystemBackground))
                    )
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height, alignment: .center) // Center content vertically when space is available
                }
            }
        }
    }
}
