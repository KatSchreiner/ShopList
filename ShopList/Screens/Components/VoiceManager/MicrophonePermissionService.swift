//
//  MicrophonePermissionService.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 02.08.2026.
//

import UIKit
internal import AVFAudio

final class MicrophonePermissionService {
    static func request(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            switch AVAudioApplication.shared.recordPermission {
            case .granted: completion(true)
            case .denied: completion(false)
            case .undetermined:
                AVAudioApplication.requestRecordPermission { completion($0) }
            @unknown default:
                completion(false)
            }
        } else {
            let session = AVAudioSession.sharedInstance()
            switch session.recordPermission {
            case .granted: completion(true)
            case .denied: completion(false)
            case .undetermined:
                session.requestRecordPermission { granted in
                    completion(granted)
                }
            @unknown default:
                completion(false)
            }
        }
    }
}
