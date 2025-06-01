//
//  PermissionKitManager.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/25.
//

import Foundation
import SwiftUI

/**
 * PermissionKitManager
 * 
 * A centralized registry and management system for all permission kit implementations
 * in the Flutter Permission Kit plugin. This singleton class provides a unified
 * interface for registering, accessing, and managing different permission types.
 * 
 * **Architecture Role**:
 * - **Registry Pattern**: Central repository for all permission kit instances
 * - **Service Locator**: Provides access to permission kits by type
 * - **Lifecycle Management**: Maintains permission kit instances throughout app lifecycle
 * - **Type Safety**: Ensures proper casting and type checking for permission kits
 * 
 * **Key Benefits**:
 * - **Centralized Management**: Single point of control for all permission kits
 * - **Loose Coupling**: Permission kits don't need to know about each other
 * - **Dynamic Discovery**: Runtime discovery of available permission types
 * - **Memory Efficiency**: Single instance per permission type
 * - **Thread Safety**: Safe access from multiple threads via main actor
 * 
 * **Usage Pattern**:
 * ```swift
 * // Registration (usually in app initialization)
 * let cameraKit = CameraPermissionKit()
 * PermissionKitManager.shared.registerKit(cameraKit)
 * 
 * // Access (anywhere in the app)
 * guard let kit = PermissionKitManager.shared.getKit(for: .camera) as? CameraPermissionKit else {
 *     return // Handle unavailable kit
 * }
 * kit.requestPermission()
 * ```
 * 
 * **Thread Safety**: All operations on this manager should be performed on the main thread
 * since permission kits are ObservableObjects that update UI components.
 * 
 * Requirements: iOS 15.0 or later due to protocol requirements
 */
@available(iOS 15.0, *)
class PermissionKitManager {
    
    /**
     * Shared singleton instance of PermissionKitManager
     * 
     * This provides global access to the permission kit registry throughout the app.
     * Using a singleton ensures that all permission kits are registered in the same
     * instance and can be accessed consistently from anywhere in the codebase.
     * 
     * **Thread Safety**: Access to this shared instance is thread-safe, but operations
     * on the instance should be performed on the main thread.
     */
    static let shared = PermissionKitManager()
    
    /**
     * Internal storage for registered permission kits
     * 
     * This dictionary maps PermissionType enum values to their corresponding
     * permission kit instances. Using AnyObject allows storage of different
     * permission kit types while maintaining type information for later casting.
     * 
     * **Key**: PermissionType enum (e.g., .camera, .photos)
     * **Value**: Permission kit instance conforming to PermissionKitProtocol
     * 
     * **Why AnyObject**: Swift's type system requires a common base type for
     * dictionary values. AnyObject allows us to store different permission kit
     * types while preserving the ability to cast back to specific types.
     */
    private var permissionKits: [PermissionType: AnyObject] = [:]
    
    /**
     * Private initializer to enforce singleton pattern
     * 
     * This prevents external code from creating additional instances of
     * PermissionKitManager, ensuring that all permission kits are registered
     * in the same central location.
     */
    private init() {}
    
    /**
     * Registers a permission kit for its corresponding permission type
     * 
     * This method adds a permission kit to the central registry, making it
     * available for use throughout the app. Each permission type can only
     * have one registered kit instance - registering a new kit for an existing
     * type will replace the previous registration.
     * 
     * **Generic Constraint**: T must conform to PermissionKitProtocol to ensure
     * the registered object implements the required permission kit interface.
     * 
     * - Parameter kit: The permission kit instance to register
     *   Must conform to PermissionKitProtocol and be an ObservableObject
     * 
     * **Thread Safety**: Should be called on the main thread during app initialization
     * 
     * **Example**:
     * ```swift
     * let cameraKit = CameraPermissionKit()
     * PermissionKitManager.shared.registerKit(cameraKit)
     * 
     * let photosKit = PhotosPermissionKit()
     * PermissionKitManager.shared.registerKit(photosKit)
     * ```
     */
    func registerKit<T: PermissionKitProtocol>(_ kit: T) {
        permissionKits[kit.permissionType] = kit
    }
    
    /**
     * Retrieves a permission kit for the specified permission type
     * 
     * This method looks up and returns the registered permission kit for a given
     * permission type. The returned kit can be cast to the specific permission
     * kit type for type-safe operations.
     * 
     * - Parameter permissionType: The type of permission kit to retrieve
     * 
     * - Returns: The registered permission kit instance, or nil if no kit
     *   is registered for the specified type
     * 
     * **Return Type**: Uses existential type (any PermissionKitProtocol) to allow
     * return of any conforming type while maintaining protocol guarantees.
     * 
     * **Usage Pattern**:
     * ```swift
     * // Generic access
     * if let kit = PermissionKitManager.shared.getKit(for: .camera) {
     *     kit.requestPermission()
     * }
     * 
     * // Type-specific access
     * guard let cameraKit = PermissionKitManager.shared.getKit(for: .camera) as? CameraPermissionKit else {
     *     return
     * }
     * // Use camera-specific functionality
     * ```
     */
    func getKit(for permissionType: PermissionType) -> (any PermissionKitProtocol)? {
        return permissionKits[permissionType] as? any PermissionKitProtocol
    }
    
    /**
     * Gets all registered permission kits
     * 
     * This method returns an array of all currently registered permission kits,
     * which is useful for operations that need to work with all available
     * permission types (e.g., checking status of all permissions).
     * 
     * - Returns: Array of all registered permission kit instances
     *   Empty array if no kits are registered
     * 
     * **Use Cases**:
     * - Checking status of all permissions at once
     * - Bulk permission operations
     * - Generating UI for all available permissions
     * - System health checks and diagnostics
     * 
     * **Example**:
     * ```swift
     * let allKits = PermissionKitManager.shared.getAllKits()
     * for kit in allKits {
     *     print("Permission \(kit.permissionType): \(kit.permissionStatus)")
     * }
     * ```
     */
    func getAllKits() -> [any PermissionKitProtocol] {
        return permissionKits.values.compactMap { $0 as? any PermissionKitProtocol }
    }
    
    /**
     * Checks if a kit is registered for the specified permission type
     * 
     * This method provides a quick way to verify if a permission type is
     * supported by checking if a corresponding kit has been registered.
     * Useful for defensive programming and feature availability checks.
     * 
     * - Parameter permissionType: The permission type to check
     * 
     * - Returns: true if a kit is registered for the type, false otherwise
     * 
     * **Use Cases**:
     * - Feature availability checks before showing UI
     * - Defensive programming to avoid accessing non-existent kits
     * - Configuration validation during app startup
     * - Dynamic feature discovery
     * 
     * **Example**:
     * ```swift
     * if PermissionKitManager.shared.isKitRegistered(for: .camera) {
     *     // Show camera-related UI
     *     showCameraOptions()
     * } else {
     *     // Hide camera functionality
     *     hideCameraOptions()
     * }
     * ```
     */
    func isKitRegistered(for permissionType: PermissionType) -> Bool {
        return permissionKits[permissionType] != nil
    }
    
    /**
     * Gets all registered permission types
     * 
     * This method returns a Set of all permission types that have registered
     * kits. The Set ensures uniqueness and provides efficient lookup operations
     * for checking supported permission types.
     * 
     * - Returns: Set of PermissionType values for all registered kits
     *   Empty set if no kits are registered
     * 
     * **Use Cases**:
     * - Generating configuration for Flutter layer
     * - Validating permission requests against available types
     * - Building dynamic permission selection UI
     * - System capability reporting
     * 
     * **Example**:
     * ```swift
     * let supportedTypes = PermissionKitManager.shared.getRegisteredTypes()
     * if supportedTypes.contains(.camera) && supportedTypes.contains(.photos) {
     *     // Both camera and photos are supported
     *     enableMediaFeatures()
     * }
     * ```
     */
    func getRegisteredTypes() -> Set<PermissionType> {
        return Set(permissionKits.keys)
    }
} 