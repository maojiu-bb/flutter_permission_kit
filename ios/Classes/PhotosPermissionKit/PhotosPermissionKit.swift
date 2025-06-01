//
//  PhotosPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/28.
//

import Foundation
import Photos
import SwiftUI

@available(iOS 15.0, *)
class PhotosPermissionKit: ObservableObject {
    @Published var status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
            DispatchQueue.main.async {
                self.status = newStatus
            }
        }
    }
    
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .authorized:
            return AuthorizationStatus.granted
        case .denied, .restricted:
            return AuthorizationStatus.denied
        case .limited:
            return AuthorizationStatus.limited
        case .notDetermined:
            return AuthorizationStatus.notDetermined
        }
    }
}
