Pod::Spec.new do |s|
  s.name = "ADXLibrary-Core"
  s.version = "1.0.3"
  s.summary = "ADX Library Core for iOS"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"Chiung Choi"=>"god@adxcorp.kr"}
  s.homepage = "http://www.adxcorp.kr"
  s.description = "ADX Library allows developers to easily incorporate banner, interstitial, native ads and rewarded video. It will benefit developers a lot."
  s.source = { :git => 'https://github.com/adxcorp/ADXLibrary_Core_iOS_Release.git', :tag => s.version.to_s }
  s.ios.deployment_target    = '10.0'

  s.frameworks =    'Accelerate',
                    'AdSupport',
                    'AudioToolbox',
                    'AVFoundation',
                    'CFNetwork',
                    'CoreGraphics',
                    'CoreMotion',
                    'CoreMedia',
                    'CoreTelephony',
                    'Foundation',
                    'GLKit',
                    'MobileCoreServices',
                    'MediaPlayer',
                    'QuartzCore',
                    'StoreKit',
                    'SystemConfiguration',
                    'UIKit',
                    'VideoToolbox',
                    'WebKit'
                    
  s.ios.vendored_framework   =  'ios/ADXLibraryCore.framework'
  
  s.dependency 'mopub-ios-sdk', '5.13.1'
  s.dependency 'Google-Mobile-Ads-SDK', '7.64.0'
  
  s.libraries = ["z", "sqlite3", "xml2", "c++"]
  
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO', 'OTHER_LDFLAGS' => '-ObjC', 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
  s.xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
end
