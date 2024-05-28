Pod::Spec.new do |s|
  s.name              = 'GripSDK'
  s.version           = '1.0.0'
  s.summary           = 'Grip iOS SDK'
  s.description       = <<-DESC
                        GripSDK is an iOS-exclusive SDK for embedding live commerce content.
                        DESC
  s.homepage          = 'https://github.com/gripcorp/grip-ios-sdk'
  s.license           = { :type => 'Proprietary', :text => 'Copyright 2024 Grip Corp. All rights reserved.' }
  s.authors           = { 'gripcorp' => 'ios_dev@gripcorp.co' }

  s.source            = {
    :http => 'https://github.com/gripcorp/grip-ios-sdk/releases/download/1.0.0/GripSDK.xcframework.zip',
    :sha256 => '3c2e25e8bc3d179af8fa11ac000442e45d3f6fc3940ebc52c11d5b1a2bd7cbb1'
  }

  s.swift_version     = '5.0'
  s.ios.deployment_target = '14.0'

  s.vendored_frameworks = 'GripSDK.xcframework'

  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'RxCocoa', '~> 6.0'
  s.dependency 'SnapKit', '~> 5.0'
  s.dependency 'SDWebImage', '~> 5.0'
  s.dependency 'Moya', '~> 15.0'

  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
end
