//
//  FeedViewController.swift
//  GripSDKSampleApp
//
//  Created by Grip on 5/27/24.
//  Copyright © 2024 Grip. All rights reserved.
//

import GripFramework
import UIKit

final class FeedViewController: UIViewController {
    private weak var collectionView: UICollectionView!
    private weak var refreshControl: UIRefreshControl!

    private var dataList: [DataType] = [.dummy, .dummy, .grip, .dummy, .dummy]

    init() {
        super.init(nibName: nil, bundle: nil)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        GripSDK.requestInitialContents { result in
            print("finish requestInitialContents: \(result)")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        GripSDK.viewDidAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        GripSDK.viewDidDisappear()
    }
}

extension FeedViewController: GripInAppWebViewControllerDelegate {
    func sharePage(url: URL) {
        print("Share URL: \(url)")
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: "https://m.naver.com")!
        let gripUrl = GripURL(webUrl: url)
        let vc = GripSDK.makeGripInAppWebViewController(url: gripUrl)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? FeedCollectionViewCell)?.notifyCellWillDisplay()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? FeedCollectionViewCell)?.notifyCellDidEndDisplaying()
    }
}

// MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if case .grip = dataList[indexPath.item] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FeedCollectionViewCell.self)", for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }

            let contentTappedBlock: (GripURL) -> Void = { [weak self] url in
                if GripSDK.canOpen(url: url) {
                    GripSDK.open(url: url)
                } else {
                    let vc = GripSDK.makeGripInAppWebViewController(url: url)
                    vc.delegate = self
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
            }

            let playButtonTappedBlock: () -> Void = {
                // TODO: [sol6521] Implement: 자동 재생 설정 바꾸도록 유도하는 얼럿 띄우기
            }

            let muteStateChangedBlock: (Bool) -> Void = { isMuted in
                if !isMuted {
                    AudioManager.shared.activate()
                } else {
                    AudioManager.shared.deactivate()
                }
            }

            cell.setItem(contentTappedBlock: contentTappedBlock, playButtonTappedBlock: playButtonTappedBlock, muteStateChangedBlock: muteStateChangedBlock)

            return cell

        } else if case .dummy = dataList[indexPath.item] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Empty", for: indexPath)
            cell.backgroundColor = .white

            return cell
        }

        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 32
        let headerComponentHeight: CGFloat = 57
        let gripContentHeight: CGFloat = GripSDK.gripContentViewHeight
        let gripContentBottomSpacing: CGFloat = 20
        let footerComponentHeight: CGFloat = 53
        let height: CGFloat = headerComponentHeight + gripContentHeight + gripContentBottomSpacing + footerComponentHeight
        return CGSize(width: width, height: height)
    }
}

extension FeedViewController {
    private func setupViews() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "\(FeedCollectionViewCell.self)")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Empty")
        collectionView.dataSource = self
        collectionView.delegate = self

        let refreshControl = UIRefreshControl()
        refreshControl.addAction(UIAction { [weak self] _ in
            GripSDK.requestContents(nil)
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }, for: .valueChanged)
        collectionView.refreshControl = refreshControl
        self.refreshControl = refreshControl

        self.collectionView = collectionView
        view.addSubview(collectionView)
    }

    private func setupLayoutConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FeedViewController {
    enum DataType {
        case grip
        case dummy
    }
}
