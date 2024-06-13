//
//  OptionsViewController.swift
//  GripSDKSampleApp
//
//  Created by Grip on 6/7/24.
//  Copyright © 2024 Grip. All rights reserved.
//

import GripFramework
import UIKit

final class OptionsViewController: UIViewController {
    enum DarkMode: String, CaseIterable {
        case followSystem
        case light
        case dark

        init(rawValue: String) {
            switch rawValue {
            case "followSystem": self = .followSystem
            case "light": self = .light
            case "dark": self = .dark
            default: self = .followSystem
            }
        }

        var optionTitle: String {
            switch self {
            case .followSystem: return "시스템 설정 모드"
            case .light: return "라이트 모드"
            case .dark: return "다크 모드"
            }
        }
    }

    enum AutoPlay: String, CaseIterable {
        case all
        case onlyWifi
        case never

        init(rawValue: String) {
            switch rawValue {
            case "all": self = .all
            case "onlyWifi": self = .onlyWifi
            case "never": self = .never
            default: self = .all
            }
        }

        var optionTitle: String {
            switch self {
            case .all: return "항상 사용"
            case .onlyWifi: return "Wi-Fi에서만 사용"
            case .never: return "사용 안함"
            }
        }
    }

    private weak var tableView: UITableView!
    private let headerData: [String] = ["자동 재생", "다크 모드"]
    private let autoPlayOptions: [AutoPlay] = AutoPlay.allCases
    private let darkModeOptions: [DarkMode] = DarkMode.allCases

    private var selectedAutoPlayOption: AutoPlay = .all
    private var selectedDarkModeOption: DarkMode = .followSystem

    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedAutoPlayOptionRawValue = UserDefaults.standard.string(forKey: UserDefaults.Key.autoPlay.rawValue) {
            let selectedAutoPlayOption = AutoPlay(rawValue: selectedAutoPlayOptionRawValue)
            self.selectedAutoPlayOption = selectedAutoPlayOption

            let selectedAutoPlayOptionIndex = autoPlayOptions.firstIndex(of: selectedAutoPlayOption) ?? 0
            tableView.cellForRow(at: IndexPath(row: selectedAutoPlayOptionIndex, section: 0))?.accessoryType = .checkmark
        }

        if let selectedDarkModeOptionRawValue = UserDefaults.standard.string(forKey: UserDefaults.Key.darkMode.rawValue) {
            let selectedDarkModeOption = DarkMode(rawValue: selectedDarkModeOptionRawValue)
            self.selectedDarkModeOption = selectedDarkModeOption

            let selectedDarkModeOptionIndex = darkModeOptions.firstIndex(of: selectedDarkModeOption) ?? 0
            tableView.cellForRow(at: IndexPath(row: selectedDarkModeOptionIndex, section: 1))?.accessoryType = .checkmark
        }
    }
}

extension OptionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return autoPlayOptions.count
        case 1: return darkModeOptions.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = autoPlayOptions[indexPath.row].optionTitle
            cell.accessoryType = selectedAutoPlayOption == autoPlayOptions[indexPath.row] ? .checkmark : .none

        case 1:
            cell.textLabel?.text = darkModeOptions[indexPath.row].optionTitle
            cell.accessoryType = selectedDarkModeOption == darkModeOptions[indexPath.row] ? .checkmark : .none

        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedAutoPlayOption = autoPlayOptions[indexPath.row]
            saveAutoPlayOption(to: autoPlayOptions[indexPath.row])
        case 1:
            selectedDarkModeOption = darkModeOptions[indexPath.row]
            saveDarkModeOption(to: darkModeOptions[indexPath.row])
        default: break
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerData[section]
    }
}

extension OptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension OptionsViewController {
    private func saveAutoPlayOption(to option: AutoPlay) {
        let autoPlayOption: GripVideoAutoPlayOption
        switch option {
        case .all:
            autoPlayOption = .all
        case .onlyWifi:
            autoPlayOption = .onlyWifi
        case .never:
            autoPlayOption = .none
        }

        UserDefaults.standard.set(option.rawValue, forKey: UserDefaults.Key.autoPlay.rawValue)
        GripSDK.setAutoPlayOption(autoPlayOption)
    }

    private func saveDarkModeOption(to option: DarkMode) {
        let systemDarkModeOption = traitCollection.userInterfaceStyle

        let isDarkMode: Bool
        switch option {
        case .followSystem:
            isDarkMode = systemDarkModeOption == .dark
        case .light:
            isDarkMode = false
        case .dark:
            isDarkMode = true
        }

        UserDefaults.standard.set(option.rawValue, forKey: UserDefaults.Key.darkMode.rawValue)
        GripSDK.setDarkMode(isDarkMode)
    }

    private func setupViews() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        tableView.sectionHeaderHeight = 15
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        self.tableView = tableView
    }

    private func setupLayoutConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
