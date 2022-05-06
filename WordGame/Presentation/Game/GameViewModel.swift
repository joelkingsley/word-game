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
    
    var gameState = GameState(
        correctAttempts: 0,
        inCorrectAttempts: 0,
        currentWordPair: nil,
        wordPairsSeen: 0
    )
    
    var roundTimer: RoundTimer?
    
    // MARK: - Methods
    
    /// Gets a random word pair
    func getRandomWordPair() -> Result<WordPair, Error> {
        return getRandomWordPairUseCase.execute().map { [weak self] wordPair in
            self?.gameState.currentWordPair = wordPair
            self?.gameState.wordPairsSeen += 1
            return wordPair
        }
    }
    
    /// Validates user response and returns updated tuple of correct and incorrect attempts
    func validateUserResponse(isCorrect: Bool) -> Result<(Int, Int), Error> {
        guard let currentWordPair = gameState.currentWordPair else {
            return .failure(NSError(domain: "Not Found", code: 404, userInfo: nil))
        }

        if currentWordPair.isCorrectTranslation == isCorrect {
            gameState.correctAttempts += 1
        } else {
            gameState.inCorrectAttempts += 1
        }
        return .success((gameState.correctAttempts, gameState.inCorrectAttempts))
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
        return gameState.inCorrectAttempts >= 3 || gameState.wordPairsSeen >= 15
    }
}
