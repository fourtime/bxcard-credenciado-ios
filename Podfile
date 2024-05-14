# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'BXCard' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AttiveCard
  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift'
  pod 'VMaskTextField'
  pod 'InputMask'
  pod 'Firebase'
  pod 'FirebaseMessaging'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end
  
end
