//
//  HealthPermissionKit.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Foundation
import HealthKit
import SwiftUI

/**
 * HealthPermissionKit
 *
 * A specialized permission management class for handling health data access permissions in iOS.
 * This class implements the PermissionKitProtocol to provide a unified interface for health permission handling.
 * It manages the health data authorization status and provides methods to request permissions and create UI components.
 *
 * Key Features:
 * - Tracks real-time health data permission status using HealthKit
 * - Provides methods to request health data access permissions
 * - Creates UI components for permission request flows
 * - Maps system authorization status to unified permission states
 * - Handles both read and write health data permissions
 *
 * Requirements: iOS 15.0 or later, HealthKit framework
 */
@available(iOS 15.0, *)
class HealthPermissionKit: ObservableObject, PermissionKitProtocol {
    
    /**
     * HealthKit store instance for managing health data access
     *
     * This is the main interface to the HealthKit framework, used for:
     * - Checking health data availability
     * - Requesting permission for specific health data types
     * - Reading and writing health data
     * - Monitoring authorization status changes
     */
    private let healthStore = HKHealthStore()
    
    /**
     * Published property that tracks the current health authorization status
     *
     * This property is automatically updated when permission status changes and will
     * trigger UI updates in SwiftUI views that observe this object.
     * Uses a simplified authorization status for UI display purposes.
     */
    @Published var status: HKAuthorizationStatus = .notDetermined
    
    /**
     * Set of health data types to request for reading
     *
     * These are the health data types that the app wants to read from HealthKit.
     * Common examples include steps, heart rate, workouts, etc.
     * This can be customized based on the app's specific needs.
     */
    private let healthDataTypesToRead: Set<HKObjectType> = {
        var types = Set<HKObjectType>()
        
        // Activity data types
        if let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount) {
            types.insert(stepCount)
        }
        if let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) {
            types.insert(distanceWalkingRunning)
        }
        if let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) {
            types.insert(activeEnergyBurned)
        }
        
        // Vital signs
        if let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) {
            types.insert(heartRate)
        }
        
        // Workouts
        types.insert(HKObjectType.workoutType())
        
        return types
    }()
    
    /**
     * Set of health data types to request for writing
     *
     * These are the health data types that the app wants to write to HealthKit.
     * This allows the app to contribute data to the user's health records.
     */
    private let healthDataTypesToWrite: Set<HKSampleType> = {
        var types = Set<HKSampleType>()
        
        // Allow writing basic activity data
        if let stepCount = HKSampleType.quantityType(forIdentifier: .stepCount) {
            types.insert(stepCount)
        }
        if let activeEnergyBurned = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) {
            types.insert(activeEnergyBurned)
        }
        
        // Allow writing workouts
        types.insert(HKSampleType.workoutType())
        
        return types
    }()
    
    /**
     * Initializer for HealthPermissionKit
     *
     * Sets up the health permission kit and checks initial authorization status.
     * Also verifies that HealthKit is available on the current device.
     */
    init() {
        updateAuthorizationStatus()
    }
    
    /**
     * Computed property that returns the permission type identifier
     *
     * This property is required by the PermissionKitProtocol and identifies
     * this kit as handling health permissions specifically.
     *
     * Returns: PermissionType.health - indicates this kit handles health permissions
     */
    var permissionType: PermissionType {
        return .health
    }
    
    /**
     * Requests health data access permission from the user
     *
     * This method triggers the system permission dialog for health data access.
     * It uses HKHealthStore.requestAuthorization to prompt the user for permission.
     * After the user responds, it updates the status property on the main thread
     * to ensure UI updates happen correctly.
     *
     * The method handles both read and write permissions for the specified health data types.
     *
     * Flow:
     * 1. Checks if HealthKit is available on the device
     * 2. Calls HKHealthStore.requestAuthorization for specified data types
     * 3. Receives callback with success/error result
     * 4. Updates the status property on main thread
     * 5. SwiftUI views observing this object will automatically update
     */
    func requestPermission(completion: ((AuthorizationStatus) -> Void)? = nil) {
        // Check if HealthKit is available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device")
            DispatchQueue.main.async {
                self.status = .notDetermined
            }
            return
        }
        
        // Request authorization for health data types
        healthStore.requestAuthorization(toShare: healthDataTypesToWrite, read: healthDataTypesToRead) { (success, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting health authorization: \(error.localizedDescription)")
                    self.status = .notDetermined
                    completion?(self.permissionStatus)
                } else {
                    // Update authorization status after request
                    self.updateAuthorizationStatus()
                    completion?(self.permissionStatus)
                }
            }
        }
    }
    
    /**
     * Updates the current authorization status based on HealthKit permissions
     *
     * This method checks the authorization status for the health data types
     * and updates the published status property accordingly.
     *
     * Note: HealthKit permissions are granular - users can approve/deny individual data types.
     * This method provides a simplified overall status for UI purposes.
     */
    private func updateAuthorizationStatus() {
        guard HKHealthStore.isHealthDataAvailable() else {
            self.status = .notDetermined
            return
        }
        
        // Check authorization status for read permissions
        let readStatuses = healthDataTypesToRead.map { dataType in
            healthStore.authorizationStatus(for: dataType)
        }
        
        // Determine overall status based on individual permissions
        if readStatuses.contains(.sharingAuthorized) {
            self.status = .sharingAuthorized
        } else if readStatuses.contains(.sharingDenied) {
            self.status = .sharingDenied
        } else {
            self.status = .notDetermined
        }
    }
    
    /**
     * Computed property that maps HKAuthorizationStatus to unified AuthorizationStatus
     *
     * This property converts the HealthKit-specific HKAuthorizationStatus enum values
     * to the unified AuthorizationStatus enum used throughout the permission kit.
     * This abstraction allows consistent permission handling across different permission types.
     *
     * Mapping:
     * - .sharingAuthorized → .granted: User has granted health data access
     * - .sharingDenied → .denied: User has explicitly denied health data access
     * - .notDetermined → .notDetermined: User hasn't been asked for permission yet
     * - @unknown default → .notDetermined: Future unknown cases default to not determined
     *
     * Returns: AuthorizationStatus - unified permission status enum value
     */
    var permissionStatus: AuthorizationStatus {
        switch status {
        case .sharingAuthorized:
            return .granted
        case .sharingDenied:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            // Handle any future unknown authorization status cases
            return .notDetermined
        }
    }
    
    /**
     * Creates a SwiftUI view component for health permission requests
     *
     * This method generates a health-specific permission card UI component that can be
     * embedded in permission request flows. The card includes customizable title and
     * description text, and calls the completion handler when permission flow is complete.
     *
     * Parameters:
     * - title: Optional custom title for the permission card (defaults to "Health Data" if nil)
     * - description: Optional custom description text (defaults to standard message if nil)
     * - onPermissionsCompleted: Callback function executed when permission request is complete
     *
     * Returns: AnyView - Type-erased SwiftUI view containing the health permission card
     *
     * Usage:
     * ```swift
     * let permissionCard = healthKit.createPermissionCard(
     *     title: "Health Data Access",
     *     description: "This app needs access to your health data to provide personalized fitness insights"
     * ) {
     *     print("Health permission request completed")
     * }
     * ```
     */
    func createPermissionCard(
        title: String?,
        description: String?,
        onPermissionsCompleted: @escaping () -> Void
    ) -> AnyView {
        return AnyView(
            HealthPermissionCard(
                title: title,
                description: description,
                onPermissionsCompleted: onPermissionsCompleted
            )
        )
    }
}
