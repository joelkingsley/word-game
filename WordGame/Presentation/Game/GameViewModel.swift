//
//  GameViewModel.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import Foundation

/**
 View Model for the `GameViewController`
 */
class GameViewModel {
    // MARK: - Use Cases
    
    let getRandomWordPairUseCase = GetRandomWordPairUseCase(wordPairRepository: WordPairRepositoryImpl.sharedInstance)
    
    // MARK: - Properties
    
    var correctAttempts = 0
    var inCorrectAttempts = 0
    
    var currentWordPair: WordPair?
    
    // MARK: - Methods
    
    /// Gets a random word pair
    func getRandomWordPair() -> Result<WordPair, Error> {
        return getRandomWordPairUseCase.execute().map { [weak self] wordPair in
            self?.currentWordPair = wordPair
            return wordPair
        }
    }
    
    /// Validates user response and returns updated tuple of correct and incorrect attempts
    func validateUserResponse(isCorrect: Bool) -> Result<(Int, Int), Error> {
        guard let currentWordPair = currentWordPair else {
            return .failure(NSError(domain: "Not Found", code: 404, userInfo: nil))
        }

        if currentWordPair.isCorrectTranslation == isCorrect {
            correctAttempts += 1
        } else {
            inCorrectAttempts += 1
        }
        return .success((correctAttempts, inCorrectAttempts))
    }
}
