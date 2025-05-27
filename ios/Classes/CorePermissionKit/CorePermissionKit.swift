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
    
    func initPermissionKit(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let config = FlutterPermissionKitConfig(from: args) else {
            result(false)
            return
        }
        
        self.config = config
        
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
//            TODO: Add Permission Card Here
            Text("Card")
        }
        
        let hostingController = UIHostingController(rootView: corePermissionView)
        
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
            topViewController.present(hostingController, animated: true)
            return true
        }
        
        return false
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
