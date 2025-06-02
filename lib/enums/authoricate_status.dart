// Authorization status

/// Represents the current authorization status of a permission request on iOS
///
/// This enum defines the possible states that a permission can be in after
/// the user has been prompted or when checking the current permission status.
/// These statuses align with standard iOS permission states and are mapped
/// from iOS framework-specific authorization status enums.
enum AuthorizationStatus {
  /// Permission has been granted by the user
  ///
  /// The user has explicitly allowed the app to access the requested feature
  /// or resource through the iOS system permission dialog. The app can proceed
  /// with the functionality that requires this permission without further prompting.
  granted,

  /// Permission has been denied by the user
  ///
  /// The user has explicitly refused to grant the permission through the iOS
  /// system dialog. On iOS, this typically means the user tapped "Don't Allow"
  /// or similar option. Further requests may require directing the user to
  /// iOS Settings app to manually enable the permission.
  denied,

  /// Permission has been granted with limitations
  ///
  /// The user has granted partial access to the requested permission.
  /// This is commonly seen with iOS photo library access where the user can
  /// select specific photos rather than granting full library access.
  /// Available on iOS 14+ and represents limited access authorization states.
  limited,

  /// Permission status has not been determined yet
  ///
  /// The user has not yet been asked for this permission, or the permission
  /// request is still pending. This is the initial state for most iOS permissions
  /// before any user interaction has occurred through the system permission dialog.
  notDetermined,
}
