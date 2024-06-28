Pod::Spec.new do |s|
  s.name              = 'GripFramework'
  s.version           = '1.0.15'
  s.summary           = 'Grip iOS SDK'
  s.description       = <<-DESC
                        GripFramework is an iOS-exclusive SDK for embedding live commerce content.
                        DESC
  s.homepage          = 'https://github.com/gripcorp/grip-ios-sdk'
  s.license           = { :type => 'Proprietary', :text => 'Copyright 2024 Grip Corp. All rights reserved.' }
  s.authors           = { 'gripcorp' => 'ios_dev@gripcorp.co' }

  s.source            = {
    :http => 'https://github.com/gripcorp/grip-ios-sdk/releases/download/1.0.15/GripFramework.xcframework.zip',
    :sha256 => 'e9d292a3b27bbaf86981d0467c1aadeab86bf167b563f4896227a2aa95a9e81b'
  }

  s.swift_version     = '5.0'
  s.ios.deployment_target = '14.0'

  s.vendored_frameworks = 'GripFramework.xcframework'

  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'RxCocoa', '~> 6.0'
  s.dependency 'SnapKit', '~> 5.0'
  s.dependency 'SDWebImage', '~> 5.0'
  s.dependency 'Moya', '~> 15.0'
  s.dependency 'RxAppState', '~> 1.0'
  s.dependency 'ReachabilitySwift', '~> 5.2.0'
end
