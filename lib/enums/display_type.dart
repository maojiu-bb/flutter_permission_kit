// Display type
/// Defines the display type for permission request dialogs
///
/// This enum specifies how the permission request interface should be presented
/// to the user when requesting permissions through the Flutter Permission Kit.
///
/// Available display types:
/// - [alert]: Shows a system-style alert dialog (recommended for iOS-style apps)
/// - [modal]: Shows a full-screen modal presentation (recommended for custom UI)
enum DisplayType {
  /// Display permission request as a system alert dialog
  ///
  /// This option presents the permission request in a compact alert dialog
  /// that appears over the current screen content. It's ideal for simple
  /// permission requests that don't require extensive explanation.
  alert,

  /// Display permission request as a full-screen modal
  ///
  /// This option presents the permission request in a full-screen modal
  /// that takes over the entire screen. It's ideal for complex permission
  /// requests that require detailed explanations or custom UI elements.
  modal,
}
