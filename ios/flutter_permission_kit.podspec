#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_permission_kit.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_permission_kit'
  s.version          = '1.0.0'
  s.summary          = 'A comprehensive Flutter plugin for managing iOS system permissions with customizable UI and unified API.'
  s.description      = <<-DESC
Flutter Permission Kit provides a beautiful, native iOS permission management solution with support for 13 iOS permission types including Camera, Photos, Microphone, Speech Recognition, Contacts, Notifications, Location, Calendar, Tracking, Reminders, Bluetooth, Apple Music, and Siri. Features customizable Alert and Modal display modes, dark mode support, and unified API for streamlined permission management.
                       DESC
  s.homepage         = 'https://github.com/maojiu-bb/flutter_permission_kit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'maojiu-bb' => 'maojiu-bb@github.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_permission_kit_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
