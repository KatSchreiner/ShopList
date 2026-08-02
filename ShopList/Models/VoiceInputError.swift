//
//  VoiceInputError.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 01.08.2026.
//

enum VoiceInputError: Error {
    case recognizerUnavailable
    case audioSessionSetupFailed(Error)
    case engineStartFailed(Error)
    case permissionDenied
    case taskCancelled
}
