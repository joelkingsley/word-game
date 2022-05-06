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
    
    var string: String {
        switch self {
        case .gameScreenCorrectButtonLabel:
            return String(format: "gameScreenCorrectButtonLabel".localized)
        case .gameScreenWrongButtonLabel:
            return String(format: "gameScreenWrongButtonLabel".localized)
        case .gameScreenCorrectAttemptsCounter(let attempts):
            return String(format: "gameScreenCorrectAttemptsCounter".localized, attempts)
        case .gameScreenWrongAttemptsCounter(let attempts):
            return String(format: "gameScreenWrongAttemptsCounter".localized, attempts)
        }
    }
}
