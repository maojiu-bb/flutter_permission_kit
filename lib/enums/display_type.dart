// Display type
/// Defines the display type for permission request dialogs on iOS
///
/// This enum specifies how the permission request interface should be presented
/// to the user when requesting permissions through the Flutter Permission Kit on iOS.
/// The display types are designed to work seamlessly with iOS design guidelines
/// and user experience patterns.
///
/// Available display types:
/// - [alert]: Shows a system-style alert dialog (native iOS alert style)
/// - [modal]: Shows a full-screen modal presentation (iOS modal presentation)
enum DisplayType {
  /// Display permission request as a system alert dialog
  ///
  /// This option presents the permission request in a compact alert dialog
  /// that appears over the current screen content, following iOS Human Interface
  /// Guidelines for alert presentations. It's ideal for simple permission requests
  /// that don't require extensive explanation and maintains the native iOS feel.
  alert,

  /// Display permission request as a full-screen modal
  ///
  /// This option presents the permission request in a full-screen modal
  /// that takes over the entire screen using iOS modal presentation style.
  /// It's ideal for complex permission requests that require detailed explanations
  /// or custom UI elements while maintaining iOS design patterns.
  modal,
}
