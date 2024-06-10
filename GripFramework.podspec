Pod::Spec.new do |s|
  s.name              = 'GripFramework'
  s.version           = '0.0.12'
  s.summary           = 'Grip iOS SDK'
  s.description       = <<-DESC
                        GripFramework is an iOS-exclusive SDK for embedding live commerce content.
                        DESC
  s.homepage          = 'https://github.com/gripcorp/grip-ios-sdk'
  s.license           = { :type => 'Proprietary', :text => 'Copyright 2024 Grip Corp. All rights reserved.' }
  s.authors           = { 'gripcorp' => 'ios_dev@gripcorp.co' }

  s.source            = {
    :http => 'https://github.com/gripcorp/grip-ios-sdk/releases/download/0.0.12/GripFramework.xcframework.zip',
    :sha256 => 'e81b6f95e3c108baffc6778e0bbe12a6a9aed11c015541c285a2acd3dcebc5cb'
  }

  s.swift_version     = '5.0'
  s.ios.deployment_target = '14.0'

  s.vendored_frameworks = 'GripFramework.xcframework'

  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'RxCocoa', '~> 6.0'
  s.dependency 'SnapKit', '~> 5.0'
  s.dependency 'SDWebImage', '~> 5.0'
  s.dependency 'Moya', '~> 15.0'
  s.dependency 'Moya/RxSwift'
  s.dependency 'RxAppState', '~> 1.0'
  s.dependency 'ReachabilitySwift', '~> 5.2.0'
end
