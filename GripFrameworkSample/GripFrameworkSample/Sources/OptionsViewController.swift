//
//  OptionsViewController.swift
//  GripSDKSampleApp
//
//  Created by Grip on 6/7/24.
//  Copyright © 2024 Grip. All rights reserved.
//

import GripFramework
import RxSwift
import UIKit

final class OptionsViewController: UIViewController {
    private weak var tableView: UITableView!
    private var dataList: [String] = ["자동 재생", "다크 모드"]
    private let autoPlayChangedSubject = PublishSubject<Bool>()
    private let darkModeChangedSubject = PublishSubject<Bool>()

    private let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
        setupLayoutConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataList[indexPath.row]
        let cell: UITableViewCell
        switch data {
        case "자동 재생":
            guard let switchCell = tableView.dequeueReusableCell(withIdentifier: "Settings", for: indexPath) as? SettingsSwitchTableViewCell else {
                return UITableViewCell()
            }

            switchCell.title = "자동 재생"
            switchCell.switchValueSubject = autoPlayChangedSubject.asObserver()
            cell = switchCell

        case "다크 모드":
            guard let switchCell = tableView.dequeueReusableCell(withIdentifier: "Settings", for: indexPath) as? SettingsSwitchTableViewCell else {
                return UITableViewCell()
            }

            switchCell.title = "다크 모드"
            switchCell.switchValueSubject = darkModeChangedSubject.asObserver()
            cell = switchCell

        default: cell = UITableViewCell()
        }

        return cell
    }
}

extension OptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension OptionsViewController {
    private func bind() {
        autoPlayChangedSubject.asObservable()
            .subscribe(onNext: { allowAutoPlay in
                // TODO: [sol6521] 임시 코드
                let autoPlayOption: GripSDK.VideoAutoPlayOption
                if allowAutoPlay {
                    autoPlayOption = .all
                } else {
                    autoPlayOption = .none
                }

                GripSDK.setAutoPlayOption(autoPlayOption)
            })
            .disposed(by: disposeBag)

        darkModeChangedSubject.asObservable()
            .subscribe(onNext: { isDarkMode in
                GripSDK.setDarkMode(isDarkMode)
            })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(SettingsSwitchTableViewCell.self, forCellReuseIdentifier: "Settings")
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

final class SettingsSwitchTableViewCell: UITableViewCell {
    private weak var iconImageView: UIImageView!
    private weak var stackView: UIStackView!
    private weak var titleLabel: UILabel!
    private weak var descLabel: UILabel!
    private weak var switchView: UISwitch!
    private weak var separatorView: UIView!

    private var disposeBag = DisposeBag()

    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
            iconImageView.snp.updateConstraints {
                $0.width.equalTo(iconImage == nil ? 0 : 40)
            }
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var desc: String? {
        didSet {
            descLabel.text = desc
            descLabel.isHidden = desc == nil
        }
    }

    var descHighlight: String? {
        didSet {
            desc = descHighlight
            descLabel.textColor = .black
        }
    }

    var on = false {
        didSet {
            switchView.setOn(on, animated: false)
        }
    }

    var enabled = true {
        didSet {
            self.enabled(enabled)
        }
    }

    var switchValueSubject: AnyObserver<Bool>? {
        didSet {
            guard let switchValueSubject = switchValueSubject else {
                return
            }

            switchView.rx.controlEvent(.valueChanged)
                .withLatestFrom(switchView.rx.value)
                .asDriver(onErrorJustReturn: false)
                .drive(switchValueSubject)
                .disposed(by: disposeBag)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        enabled = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        switchView.layer.cornerRadius = switchView.frame.height / 2
    }

    func setItem(title: String, isSwitchOn: Bool, switchOnOffHandler: @escaping (Bool) -> Void) {
        self.title = title
        self.on = isSwitchOn

        switchView.rx.controlEvent(.valueChanged)
            .withLatestFrom(switchView.rx.value)
            .subscribe(onNext: switchOnOffHandler)
            .disposed(by: disposeBag)
    }
}

private extension SettingsSwitchTableViewCell {
    func enabled(_ enabled: Bool) {
        switchView.isEnabled = enabled
        switchView.alpha = enabled ? 1 : 0.3
        titleLabel.alpha = enabled ? 1 : 0.3
        descLabel.alpha = enabled ? 1 : 0.3
    }

    func setupViews() {
        selectionStyle = .none
        contentView.backgroundColor = .gray
        translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView()
        iconImageView.contentMode = .left
        contentView.addSubview(iconImageView)
        self.iconImageView = iconImageView

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        contentView.addSubview(stackView)
        self.stackView = stackView

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = .white
        stackView.addArrangedSubview(titleLabel)
        self.titleLabel = titleLabel

        let descLabel = UILabel()
        descLabel.font = .systemFont(ofSize: 12)
        descLabel.textColor = .yellow
        descLabel.numberOfLines = 0
        descLabel.isHidden = true
        stackView.addArrangedSubview(descLabel)
        self.descLabel = descLabel

        let switchView = UISwitch()
        switchView.tintColor = .black
        switchView.backgroundColor = .white
        switchView.onTintColor = .blue
        contentView.addSubview(switchView)
        self.switchView = switchView

        let separatorView = UIView()
        separatorView.backgroundColor = .black
        contentView.addSubview(separatorView)
        self.separatorView = separatorView
    }

    func setupLayoutConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
            make.width.equalTo(0)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalTo(iconImageView.snp.trailing)
            make.trailing.equalTo(switchView.snp.leading).offset(-5)
        }

        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
