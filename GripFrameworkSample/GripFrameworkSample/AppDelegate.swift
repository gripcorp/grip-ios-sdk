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

        NotificationCenter.default.addObserver(self, selector: #selector(didChangeUserInterfaceStyle), name: UIApplication.didBecomeActiveNotification, object: nil)

        let window = UIWindow(frame: UIScreen.main.bounds)
        let isDarkMode = getDarkModeOption(of: window)
        let autoPlayOption = getAutoPlayOption()

        let config = GripConfig(appKey: "0a503b68e22747a3807596f31c68a6e4",
                                appName: "GripSDKSample",
                                phase: .debug,
                                isDarkMode: isDarkMode,
                                autoPlayOption: autoPlayOption)
        GripSDK.initialize(config: config) { result in
            print("initialize result: \(result)")
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

    private func getDarkModeOption(of window: UIWindow) -> Bool {
        let systemDarkModeOption = window.traitCollection.userInterfaceStyle
        let userDefaultsDarkModeOption = UserDefaults.standard.object(forKey: UserDefaults.Key.darkMode.rawValue) as? OptionsViewController.DarkMode

        switch userDefaultsDarkModeOption {
        case .followSystem:
            return systemDarkModeOption == .dark
        case .light:
            return false
        case .dark:
            return true
        default:
            UserDefaults.standard.set(OptionsViewController.DarkMode.followSystem.rawValue, forKey: UserDefaults.Key.darkMode.rawValue)
            return systemDarkModeOption == .dark
        }
    }

    private func getAutoPlayOption() -> GripVideoAutoPlayOption {
        let userDefaultsAutoPlayOption = UserDefaults.standard.object(forKey: UserDefaults.Key.autoPlay.rawValue) as? OptionsViewController.AutoPlay

        switch userDefaultsAutoPlayOption {
        case .all:
            UserDefaults.standard.set("항상 사용", forKey: UserDefaults.Key.autoPlay.rawValue)
            return .all
        case .onlyWifi:
            return .onlyWifi
        case .never:
            return .none
        default:
            UserDefaults.standard.set(OptionsViewController.AutoPlay.all.rawValue, forKey: UserDefaults.Key.autoPlay.rawValue)
            return .all
        }
    }
}

extension UserDefaults {
    enum Key: String {
        case autoPlay
        case darkMode
    }
}
