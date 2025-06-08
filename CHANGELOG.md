## 1.2.0

### ✨ New Features

- **MotionPermissionKit**: Added motion and fitness data permission management using Apple's CoreMotion framework

## 1.1.0

### ✨ New Features

- **HealthPermissionKit**: Added health data permission management using Apple's HealthKit framework

## 1.0.1

### 🔧 Improvements

- **Kit Auto Registration**: Implemented automatic permission kit registration based on configuration
- **Siri Configuration Guide**: Added comprehensive Siri permission setup tutorial with Xcode instructions
- **Documentation Fixes**: Fixed various documentation errors and improved clarity

## 1.0.0

### 🎉 Initial Release - Major Features Launch

#### ✨ Core Features

- **Complete iOS Permission Management**: Introduced comprehensive support for 13 iOS system permission types
- **Unified API**: Single initialization method `FlutterPermissionKit.init()` for streamlined permission management
- **Type-Safe Implementation**: Full enum definitions and comprehensive error handling for robust development

#### 📱 Supported Permissions

- **Camera**: Photo and video capture using AVFoundation framework
- **Photos**: Photo library access and management via Photos framework
- **Microphone**: Audio recording capabilities through AVFoundation
- **Speech Recognition**: Voice-to-text conversion using Speech framework
- **Contacts**: Address book access via Contacts framework
- **Push Notifications**: Local and remote notification permissions via UserNotifications
- **Location Services**: GPS and location access through CoreLocation
- **Calendar Events**: Calendar management using EventKit framework
- **App Tracking Transparency**: iOS 14.5+ tracking permission support
- **Reminders**: Reminders app integration via EventKit
- **Bluetooth**: Bluetooth device access through CoreBluetooth
- **Apple Music**: Music library access via MediaPlayer framework
- **Siri Integration**: Voice command support using Intents framework

#### 🎨 UI Components

- **Dual Display Modes**: Support for both Alert and Modal presentation styles
- **Dark Mode Support**: Automatic adaptation to iOS system theme preferences
- **Customizable Interface**: Fully configurable titles, descriptions, and messaging
- **Native iOS Design**: Seamless integration with iOS design patterns and guidelines

#### 🔧 Configuration Options

- **FlutterPermissionKitConfig**: Comprehensive configuration class for customization
- **Permission Class**: Individual permission definition with name, description, and type
- **Display Customization**: Header descriptions, bottom descriptions, and title customization
- **Flexible Permission Groups**: Support for requesting multiple permissions simultaneously

#### 📚 Documentation & Examples

- **Comprehensive README**: Detailed setup instructions and usage examples
- **iOS Setup Guide**: Complete Info.plist configuration with all permission descriptions
- **Code Examples**: Basic and advanced implementation patterns
- **Platform Requirements**: iOS 15.0+ minimum deployment target

#### 🛡️ Technical Implementation

- **Method Channel Communication**: Efficient Flutter-to-iOS native communication
- **Modular Architecture**: Separate permission kits for each iOS framework
- **Error Handling**: Robust error management and status reporting
- **Authorization Status Tracking**: Complete permission state management

#### 🚀 Platform Support

- **iOS Only**: Specialized iOS permission management (iOS 15.0+)
- **Flutter 3.3.0+**: Compatible with modern Flutter versions
- **Dart 3.7.2+**: Leveraging latest Dart language features
