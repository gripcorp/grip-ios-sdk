//
//  GRIPTabBarController.swift
//  GripSDKSampleApp
//
//  Created by Grip on 5/27/24.
//  Copyright © 2024 Grip. All rights reserved.
//

import UIKit

final class GripSDKTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .systemBackground
    }
}
