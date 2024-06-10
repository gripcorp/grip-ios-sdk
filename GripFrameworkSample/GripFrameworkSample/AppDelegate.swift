//
//  AppDelegate.swift
//  Grip
//
//  Created by Grip on 24/05/2024
//  Copyright © 2023 Grip Corp. All rights reserved.
//

import GripFramework
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var navigator: SampleNavigator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // 다크모드 변동 여부를 확인하기 위함
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeUserInterfaceStyle), name: UIApplication.didBecomeActiveNotification, object: nil)

        let window = UIWindow(frame: UIScreen.main.bounds)
        let isDarkMode = window.traitCollection.userInterfaceStyle == .dark     // 현재 DarMode인지 확인
        let autoPlayOption = GripSDK.VideoAutoPlayOption.onlyWifi                                              // 임의로 AutoPlay를 false로 설정

        let config = GripSDK.Config(appKey: "456e7eb51efe4857bfcf6e46312e2c76", appName: "Kakaostory", appBundleID: "com.kakaocorp.kakaostory", appVersion: "3.1.4", phase: .debug, isDarkMode: isDarkMode, autoPlayOption: autoPlayOption)
        GripSDK.initialize(config: config) { result in
            print("@@@initialize done: \(result)")
        }

        self.window = window
        navigator = SampleNavigator(window: window)
        navigator?.start()

        return true
    }

    @objc
    private func didChangeUserInterfaceStyle(notification: NSNotification) {
        if let window = window {
            if window.traitCollection.userInterfaceStyle == .dark {
                GripSDK.setDarkMode(true)
            } else {
                GripSDK.setDarkMode(false)
            }
        }
    }
}
