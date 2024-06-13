//
//  FeedCollectionViewCell.swift
//  GripSDKSampleApp
//
//  Created by Grip on 5/28/24.
//  Copyright © 2024 Grip. All rights reserved.
//

import GripFramework
import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    private weak var iconImageView: UIImageView!
    private weak var headerTitleLabel: UILabel!
    private weak var gripContentView: GripContentView!
    private weak var bottomSeparatorView: UIView!
    private weak var footerButton: UIButton!

    private var contentTappedBlock: ((GripURL) -> Void)?
    private var playButtonTappedBlock: (() -> Void)?
    private var muteStateChangedBlock: ((Bool) -> Void)?
    private var footerButtonTappedBlock: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setItem(contentTappedBlock: @escaping (GripURL) -> Void,
                 playButtonTappedBlock: @escaping () -> Void,
                 muteStateChangedBlock: @escaping (Bool) -> Void,
                 footerButtonTappedBlock: @escaping () -> Void) {
        self.contentTappedBlock = contentTappedBlock
        self.playButtonTappedBlock = playButtonTappedBlock
        self.muteStateChangedBlock = muteStateChangedBlock
        self.footerButtonTappedBlock = footerButtonTappedBlock
    }

    func setHeaderComponents(image: UIImage?, title: String) {
        iconImageView.image = image
        headerTitleLabel.text = title
    }

    func setFooterButtonTitle(_ title: String) {
        footerButton.setTitle(title, for: .normal)
    }

    func notifyCellWillDisplay() {
        gripContentView.collectionViewCellWillDisplay()
    }

    func notifyCellDidEndDisplaying() {
        gripContentView.collectionViewCellDidEndDisplaying()
    }
}

// MARK: - GripContentViewDelegate
extension FeedCollectionViewCell: GripContentViewDelegate {
    func didChangeMuteState(to isMuted: Bool) {
        muteStateChangedBlock?(isMuted)
    }

    func didTapPlayButton() {
        playButtonTappedBlock?()
    }

    func willOpenUrlToPlayVideo(url: GripURL) {
        contentTappedBlock?(url)
    }
}

// MARK: - Privates
extension FeedCollectionViewCell {
    @objc
    private func footerButtonTapped() {
        footerButtonTappedBlock?()
    }

    private func setupViews() {
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15

        let iconImageView = UIImageView()
        contentView.addSubview(iconImageView)
        self.iconImageView = iconImageView

        let headerTitleLabel = UILabel()
        headerTitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        contentView.addSubview(headerTitleLabel)
        self.headerTitleLabel = headerTitleLabel

        let bottomSeparatorView = UIView()
        bottomSeparatorView.backgroundColor = UIColor(red: 221 / 255, green: 221 / 255, blue: 221 / 255, alpha: 1.0)
        contentView.addSubview(bottomSeparatorView)
        self.bottomSeparatorView = bottomSeparatorView

        let footerButton = UIButton()
        footerButton.titleLabel?.font = .systemFont(ofSize: 14)
        footerButton.setTitleColor(.black, for: .normal)
        footerButton.addTarget(self, action: #selector(footerButtonTapped), for: .touchUpInside)
        contentView.addSubview(footerButton)
        self.footerButton = footerButton

        let gripContentView = GripSDK.makeGripContentView { supplementaryInfo in
            iconImageView.image = supplementaryInfo?.headerIconImage
            headerTitleLabel.text = supplementaryInfo?.headerTitle
            footerButton.setTitle(supplementaryInfo?.footerTitle, for: .normal)
        }
        gripContentView.delegate = self
        contentView.addSubview(gripContentView)
        self.gripContentView = gripContentView
    }

    private func setupLayoutConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(23)
            make.size.equalTo(16)
        }

        headerTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)
            make.top.equalTo(iconImageView)
            make.trailing.equalToSuperview().inset(58)
        }

        gripContentView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
        }

        bottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(gripContentView.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }

        footerButton.snp.makeConstraints { make in
            make.top.equalTo(bottomSeparatorView.snp.bottom)
            make.height.equalTo(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
