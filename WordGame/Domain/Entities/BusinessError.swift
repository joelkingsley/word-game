//
//  BusinessError.swift
//  WordGame
//
//  Created by Joel Kingsley on 08/05/2022.
//

import Foundation

typealias BusinessError = Error

enum BusinessErrors: BusinessError {
    // Generic Errors
    struct clientError: BusinessError {}
    
    // Word Pair Errors
    struct emptyWordList: BusinessError {}
}

extension BusinessErrors.clientError: LocalizedError {
    var errorDescription: String? {
        return "Client error"
    }
}

extension BusinessErrors.emptyWordList: LocalizedError {
    var errorDescription: String? {
        return "Empty word list in file"
    }
}
