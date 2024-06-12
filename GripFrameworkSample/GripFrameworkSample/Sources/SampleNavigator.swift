//
//  SampleNavigator.swift
//  GripSDKSampleApp
//
//  Created by Grip on 6/10/24.
//  Copyright © 2024 Grip. All rights reserved.
//

import Foundation
import GripFramework
import RxSwift
import UIKit

enum Noop {
    static func noop() { }
    static func noop<T>(value: T) { }
    static func noop<T>() -> T? { return nil }
    static func noop<T, S>(value: T) -> S? { return nil }
}

final class SampleNavigator: NSObject {
    private var window: UIWindow!
    private var mainViewController: UIViewController? {
        didSet {
            registerRootViewController(mainViewController)
            if let rootViewController {
                window.rootViewController = rootViewController
            }
        }
    }

    private weak var rootViewController: UIViewController?
    private let disposeBag = DisposeBag()

    init(window: UIWindow!) {
        self.window = window
        window.makeKeyAndVisible()

        super.init()
    }

    // MARK: Public

    func start() {
        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "square.3.stack.3d"), tag: 0)
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)

        let contentsWebViewController = GripSDK.makeGripSubTabViewController()
        contentsWebViewController.delegate = self
        contentsWebViewController.tabBarItem = UITabBarItem(title: "Commerce", image: UIImage(systemName: "note"), tag: 1)

        let optionsViewController = OptionsViewController()
        optionsViewController.tabBarItem = UITabBarItem(title: "Option", image: UIImage(systemName: "gear"), tag: 2)

        let tabbarController = GripSDKTabBarController()
        tabbarController.viewControllers = [feedNavigationController, contentsWebViewController, optionsViewController]

        mainViewController = tabbarController
    }

    // MARK: Private

    private func registerRootViewController(_ viewController: UIViewController?) {
        rootViewController = viewController
        rootViewController?.rx.deallocated
            .subscribe(onNext: {
                Noop.noop(value: self)
            })
            .disposed(by: disposeBag)
    }
}

extension SampleNavigator: GripSubTabWebViewControllerDelegate {
    func executeGripURL(_ url: GripURL) {
        if GripSDK.canOpen(url: url) {
            GripSDK.open(url: url)
        } else {
            let vc = GripSDK.makeGripInAppWebViewController(url: url)
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            rootViewController?.present(vc, animated: true)
        }
    }
}

extension SampleNavigator: GripInAppWebViewControllerDelegate {
    func sharePage(url: URL) {
        // 공유된 URL을 처리하는 로직
    }
}
