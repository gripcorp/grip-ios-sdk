//
//  AudioManager.swift
//  GripSDKSampleApp
//
//  Created by Grip on 6/6/24.
//  Copyright © 2024 Grip. All rights reserved.
//

import AVFoundation
import Foundation
import RxCocoa
import RxSwift

final class AudioManager {
    static let shared = AudioManager()
    static var isMuted: Bool {
        return Self.shared.mute.value
    }

    var mute = BehaviorRelay<Bool>(value: false)

    private let syncQueue = DispatchQueue(label: "audio manager sync queue", qos: .userInitiated)
    private var audioPlayer: AVAudioPlayer?

    private init() { }

    func activate() {
        syncQueue.async {
            // 다른 앱의 소리 끄기
            let session = AVAudioSession.sharedInstance()
            let category: AVAudioSession.Category = .playback
            let mode: AVAudioSession.Mode = .moviePlayback

            if session.category == category && session.mode == mode {
                return
            }

            do {
                try session.setCategory(category, mode: mode, options: [])
                try session.setActive(true)
            } catch {
            }
        }
    }

    func deactivate() {
        syncQueue.async {
            // 다른 앱의 소리 원상 복구
            let session = AVAudioSession.sharedInstance()

            if session.category == .ambient && session.mode == .default {
                return
            }

            do {
                try session.setCategory(.ambient, mode: .default, options: [])
            } catch {
            }
        }
    }
}
