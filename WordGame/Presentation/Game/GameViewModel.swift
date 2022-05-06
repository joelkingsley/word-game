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
    
    var wordPairsSeen: Int = 0
    
    var roundTimer: RoundTimer?
    
    var roundTimerSecondsRemaining: Int = 0
    
    // MARK: - Methods
    
    /// Gets a random word pair
    func getRandomWordPair() -> Result<WordPair, Error> {
        return getRandomWordPairUseCase.execute().map { [weak self] wordPair in
            self?.currentWordPair = wordPair
            self?.wordPairsSeen += 1
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
    
    /// Initializes and starts the question timer
    func initializeAndStartRoundTimer(fireHandler: @escaping () -> Void) {
        roundTimer = RoundTimer(fireHandler: fireHandler)
        roundTimer?.start()
    }
    
    /// Resets running timer and creates a new timer for 5 seconds
    func resetRoundTimer() {
        roundTimer?.stop()
        roundTimer?.start()
    }
    
    /// Game logic to check if game should end
    func checkIfGameShouldEnd() -> Bool {
        return inCorrectAttempts >= 3 || wordPairsSeen >= 15
    }
}
