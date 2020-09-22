#
# Be sure to run `pod lib lint ADXLibrary-Core.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ADXLibrary-Core'
   s.version          = '1.0.3'
   s.summary          = 'ADX Library Core for iOS'
   s.description      = 'ADX Library allows developers to easily incorporate banner, interstitial, native ads and rewarded video. It will benefit developers a lot.'

   s.homepage         = 'http://www.adxcorp.kr'
   s.license          = { :type => 'MIT', :file => 'LICENSE' }
   s.author           = { 'Chiung Choi' => 'god@adxcorp.kr' }
   s.source           = { :git => 'https://github.com/adxcorp/ADXLibrary_Core_iOS_Release.git', :tag => s.version.to_s }

   s.ios.deployment_target = '10.0'

   s.source_files = 'ADXLibrary-Core/Classes/**/*'
   s.resources = ["ADXLibrary-Core/Assets/*"]

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
                       'SafariServices',
                       'StoreKit',
                       'SystemConfiguration',
                       'UIKit',
                       'VideoToolbox',
                       'WebKit'
     
   s.dependency 'mopub-ios-sdk', '5.13.1'
   s.dependency 'Google-Mobile-Ads-SDK', '7.64.0'
     
   s.library       = 'z', 'sqlite3', 'xml2', 'c++'

   s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO', 'OTHER_LDFLAGS' => '-ObjC', 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
   s.xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
end
