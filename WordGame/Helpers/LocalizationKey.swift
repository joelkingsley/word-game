//
//  LocalizationKey.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import Foundation

enum LocalizationKey {
    case gameScreenCorrectButtonLabel
    case gameScreenWrongButtonLabel
    case gameScreenCorrectAttemptsCounter(attempts: Int)
    case gameScreenWrongAttemptsCounter(attempts: Int)
    case gameOverModalTitle
    case gameOverModalMessage
    case gameOverModalAcceptActionLabel
    case gameOverModalRejectActionLabel
    
    var string: String {
        switch self {
        case .gameScreenCorrectButtonLabel:
            return "gameScreenCorrectButtonLabel".localized
        case .gameScreenWrongButtonLabel:
            return "gameScreenWrongButtonLabel".localized
        case .gameScreenCorrectAttemptsCounter(let attempts):
            return String(format: "gameScreenCorrectAttemptsCounter".localized, attempts)
        case .gameScreenWrongAttemptsCounter(let attempts):
            return String(format: "gameScreenWrongAttemptsCounter".localized, attempts)
        case .gameOverModalTitle:
            return "gameOverModalTitle".localized
        case .gameOverModalMessage:
            return "gameOverModalMessage".localized
        case .gameOverModalAcceptActionLabel:
            return "gameOverModalAcceptActionLabel".localized
        case .gameOverModalRejectActionLabel:
            return "gameOverModalRejectActionLabel".localized
        }
    }
}
