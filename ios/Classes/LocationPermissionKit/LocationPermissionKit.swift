//
//  LocationPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//

import Foundation
import SwiftUI
import CoreLocation

/// Location permission kit for managing GPS and location services access
/// Handles location permission requests using CoreLocation framework
@available(iOS 15.0, *)
class LocationPermissionKit: NSObject, ObservableObject, PermissionKitProtocol, CLLocationManagerDelegate {
    /// Current location authorization status from CoreLocation
    @Published var status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    
    /// Core Location manager instance for handling location permissions
    private var locationManager: CLLocationManager?
    
    /// Returns the permission type for this kit
    var permissionType: PermissionType {
        return .location
    }
    
    /// Initializes the kit with location manager and sets up delegate
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        refreshLocationStatus()
    }
    
    /// Updates the current location permission status
    func refreshLocationStatus() {
        DispatchQueue.main.async {
            self.status = CLLocationManager.authorizationStatus()
        }
    }
    
    /// Requests location access permission from the user (when-in-use)
    func requestPermission() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
    /// Converts CoreLocation authorization status to common AuthorizationStatus
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .granted
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
    }
    
    /// Delegate method called when location authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.status = status
        }
    }
    
    /// Creates a SwiftUI card for location permission request
    /// - Parameters:
    ///   - title: Custom title for the permission card
    ///   - description: Custom description for the permission request
    ///   - onPermissionsCompleted: Callback when permission flow is completed
    /// - Returns: SwiftUI view wrapped in AnyView
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView {
        return AnyView(
            LocationPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}

