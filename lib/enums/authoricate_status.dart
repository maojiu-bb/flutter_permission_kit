// Authorization status

/// Represents the current authorization status of a permission request
///
/// This enum defines the possible states that a permission can be in after
/// the user has been prompted or when checking the current permission status.
/// These statuses align with standard platform permission states on iOS and Android.
enum AuthorizationStatus {
  /// Permission has been granted by the user
  ///
  /// The user has explicitly allowed the app to access the requested feature
  /// or resource. The app can proceed with the functionality that requires
  /// this permission without further prompting.
  granted,

  /// Permission has been denied by the user
  ///
  /// The user has explicitly refused to grant the permission. On some platforms,
  /// this may also indicate that the user has selected "Don't ask again" or
  /// similar options. Further requests may require directing the user to
  /// system settings.
  denied,

  /// Permission has been granted with limitations
  ///
  /// The user has granted partial access to the requested permission.
  /// This is commonly seen with photo library access where the user can
  /// select specific photos rather than granting full library access.
  /// Available on iOS 14+ and some Android versions.
  limited,

  /// Permission status has not been determined yet
  ///
  /// The user has not yet been asked for this permission, or the permission
  /// request is still pending. This is the initial state for most permissions
  /// before any user interaction has occurred.
  notDetermined,
}
