//
//  LocationPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/6/2.
//


import Foundation
import SwiftUI
import CoreLocation

@available(iOS 15.0, *)
class LocationPermissionKit: NSObject, ObservableObject, PermissionKitProtocol, CLLocationManagerDelegate {
    @Published var status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    
    private var locationManager: CLLocationManager?
    
    var permissionType: PermissionType {
        return .location
    }
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        refreshLocationStatus()
    }
    
    func refreshLocationStatus() {
        DispatchQueue.main.async {
            self.status = CLLocationManager.authorizationStatus()
        }
    }
    
    func requestPermission() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.status = status
        }
    }
    
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

