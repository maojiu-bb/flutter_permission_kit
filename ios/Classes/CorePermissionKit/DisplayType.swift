//
//  DisplayType.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Foundation

/// Enumeration defining how permission request dialogs should be displayed
///
/// This enum specifies the visual presentation style for permission request
/// dialogs in the iOS implementation of Flutter Permission Kit. Different
/// display types provide different user experiences and visual impacts.
///
/// The display type affects:
/// - Modal presentation style
/// - Animation transitions
/// - User interaction patterns
/// - Visual hierarchy and prominence
///
/// Example usage:
/// ```swift
/// let displayType = DisplayType.alert
/// // or
/// let displayType = DisplayType(from: "modal")
/// ```
enum DisplayType: String {
    /// Alert-style presentation (UIAlertController)
    ///
    /// Presents the permission request as a native iOS alert dialog.
    /// This style provides:
    /// - Native iOS look and feel
    /// - System-standard animations
    /// - Automatic positioning and sizing
    /// - Built-in accessibility support
    /// - Less intrusive user experience
    ///
    /// Best for: Simple permission requests that don't require extensive
    /// explanation or when maintaining native iOS design consistency is important.
    case alert
    
    /// Modal-style presentation (Full-screen or sheet)
    ///
    /// Presents the permission request as a custom modal view controller.
    /// This style provides:
    /// - More space for detailed explanations
    /// - Custom UI design flexibility
    /// - Rich visual content support
    /// - Enhanced branding opportunities
    /// - More prominent user attention
    ///
    /// Best for: Complex permission requests that require detailed explanations,
    /// multiple permissions, or when custom branding is important.
    case modal
    
    /// Initializes a DisplayType from a string value
    ///
    /// This convenience initializer allows creation of DisplayType instances
    /// from string representations, which is particularly useful when parsing
    /// configuration data received from the Flutter layer.
    ///
    /// - Parameter string: The string representation of the display type
    ///   Expected values: "alert" or "modal"
    ///
    /// - Returns: A DisplayType instance if the string matches a valid case,
    ///   or nil if the string doesn't correspond to any known display type
    ///
    /// Example usage:
    /// ```swift
    /// let alertType = DisplayType(from: "alert")     // Returns .alert
    /// let modalType = DisplayType(from: "modal")     // Returns .modal
    /// let invalidType = DisplayType(from: "invalid") // Returns nil
    /// ```
    init?(from string: String) {
        self.init(rawValue: string)
    }
}
