source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

def awesome_pods
  pod 'AWSCore'
  pod 'AWSCognito'
  pod 'AWSCognitoIdentityProvider'
  pod 'AWSCognitoAuth'
  pod 'AWSS3'
  pod 'FacebookLogin', :git => 'https://github.com/facebook/facebook-sdk-swift'
  pod 'Player'
  pod 'FDWaveformView'
  #pod 'AudioKit'
  pod 'SwiftLint'
  pod 'Texture'
  pod 'CameraManager', :git => 'https://github.com/savytskyi/CameraManager'
  pod 'SVProgressHUD'
  pod 'PryntTrimmerView'
  pod 'RealmSwift'
  pod 'AWSAPIGateway'
  pod 'Reveal-SDK', :configurations => ['Debug']
  pod 'WSTagsField'
  pod 'OCWaveView'
  pod 'SwiftSiriWaveformView'
  pod 'BMPlayer', '~> 1.0.0'
  pod 'UITextView+Placeholder'
  pod 'Firebase/Core'
  pod 'Fabric', '~> 1.7.6'
  pod 'Crashlytics', '~> 3.10.1'
end

target 'YoGIF Staging' do
  awesome_pods
end

target 'YoGIF Production' do
  awesome_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          if ['Instructions'].include?(target.name)
            config.build_settings['SWIFT_VERSION'] = '3.2'
            #config.build_settings['ENABLE_BITCODE'] = 'NO'
          end
        end
    end
end
