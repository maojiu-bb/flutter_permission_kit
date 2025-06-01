//
//  CorePermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Flutter
import Foundation
import UIKit
import SwiftUI

@available(iOS 15.0, *)
class CorePermissionKit {
    
    static let share = CorePermissionKit()
    
    private var config: FlutterPermissionKitConfig?
    
    private var photosPermissionKit = PhotosPermissionKit()
    
    private var hostingController: UIHostingController<CorePermissionView<AnyView>>?
    
    // Store the presenting view controller to properly dismiss
    private var presentingViewController: UIViewController?
    
    func initPermissionKit(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let config = FlutterPermissionKitConfig(from: args) else {
            result(false)
            return
        }
        
        self.config = config
        
        // check permission status
        if !self.checkPermissionsStatus(permissions: config.permissions).values.contains(.notDetermined) {
            result(true)
            return
        }
        
        let showResult = showCorePermissionView()
        
        result(showResult)
    }
    
    func showCorePermissionView() -> Bool {
        guard let config = self.config else { return false }
        
        let corePermissionView = CorePermissionView(
            displayTitle: config.displayTitle,
            displayHeaderDescription: config.displayHeaderDescription,
            displayBottomDescription: config.displayBottomDescription
        ) {
            AnyView(self.renderPermissionCards(permissions: config.permissions))
        }
        
        let hostingController = UIHostingController(rootView: corePermissionView)
        self.hostingController = hostingController
        
        switch(config.displayType) {
        case .modal:
            hostingController.modalPresentationStyle = .formSheet
            hostingController.view.backgroundColor = UIColor.secondarySystemBackground
        case .alert:
            hostingController.modalPresentationStyle = .overFullScreen
            hostingController.view.backgroundColor = UIColor.clear
        }
        
        hostingController.isModalInPresentation = true
        
        if let topViewController = topMostViewController() {
            self.presentingViewController = topViewController
            topViewController.present(hostingController, animated: true)
            return true
        }
        
        return false
    }
    
    @ViewBuilder
    func renderPermissionCards(permissions: [PermissionItem]) -> some View {
        ForEach(permissions, id: \.type) { item in
            if item.type == .photos {
                PhotosPermissionCard(
                    title: item.name,
                    description: item.description,
                    onPermissionsCompleted: {
                        self.handlePermissionsCompleted()
                    }
                )
            }
        }
    }
    
    // Handle when all permissions are completed
    private func handlePermissionsCompleted() {
        // Allow manual dismissal first
        self.hostingController?.isModalInPresentation = false
        
        // Wait a bit for UI to update, then auto-dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismissModal()
        }
    }
    
    // Method to dismiss the modal
    private func dismissModal() {
        if let hostingController = self.hostingController {
            hostingController.dismiss(animated: true) {
                // Clean up references after dismissal
                self.hostingController = nil
                self.presentingViewController = nil
            }
        }
    }
    
    func checkPermissionsStatus(permissions: [PermissionItem]? = nil) -> [PermissionType: AuthorizationStatus] {
        let targetPermissions = permissions ?? config?.permissions ?? []
        
        var permissionsStatus: [PermissionType: AuthorizationStatus] = [:]
        
        targetPermissions.forEach { item in
            if item.type == .photos {
                permissionsStatus[.photos] = photosPermissionKit.permissionStatus
            }
            // TODO: Add more permission cards
        }
        
        return permissionsStatus
    }
    
    func topMostViewController(from root: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
            
            if let nav = root as? UINavigationController {
                return topMostViewController(from: nav.visibleViewController)
            }
            if let tab = root as? UITabBarController {
                return topMostViewController(from: tab.selectedViewController)
            }
            if let presented = root?.presentedViewController {
                return topMostViewController(from: presented)
            }
            return root
        }
}
