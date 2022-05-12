//
//  GameViewModel.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import Foundation
import Combine

/**
 View Model for the `GameViewController`
 */
class GameViewModel {
    // MARK: - Use Cases
    
    let getRandomWordPairUseCase = GetRandomWordPairUseCase(wordPairRepository: WordPairRepositoryImpl.sharedInstance)
    
    // MARK: - Properties
    
    var gameState = CurrentValueSubject<GameState, Never>(GameState())
    
    /// Property to determine whether game should end
    var shouldGameEnd: Bool {
        return gameState.value.incorrectAttempts >= 3 || gameState.value.wordPairsSeen >= 15
    }
    
    var roundTimer: RoundTimer?
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subjects
    
    var restartAnimationSubject = PassthroughSubject<Void, Never>()
    
    var endAnimationSubject = PassthroughSubject<Void, Never>()
    
    var presentGameOverModalSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Methods
    
    /// Gets a new random word pair and sets it to `currentWordPair`
    func setNextRandomWordPair() {
        let result = getRandomWordPairUseCase.execute()
        switch result {
        case let .success(wordPair):
            gameState.value.currentWordPair = wordPair
            gameState.value.wordPairsSeen += 1
        case let .failure(error):
            fatalError("Unexpectedly got error while getting random word pair: \(error)")
        }
    }
    
    /// Validates user response and updates game state
    func validateUserResponse(isCorrect: Bool) {
        if gameState.value.currentWordPair?.isCorrectTranslation == isCorrect {
            gameState.value.correctAttempts += 1
        } else {
            gameState.value.incorrectAttempts += 1
        }
    }
    
    /// Checks whether to end game, else loads next round
    func checkAndLoadNextRound() {
        if shouldGameEnd {
            roundTimer?.stop()
            endAnimationSubject.send()
            presentGameOverModalSubject.send()
            print("Game Over")
        } else {
            setNextRandomWordPair()
            resetRoundTimer()
            restartAnimationSubject.send()
            print("Loading next round")
        }
    }
    
    /// Initializes and starts the question timer
    func initializeAndStartRoundTimer() {
        roundTimer = RoundTimer(fireHandler: { [weak self] in
            /*
             NOTE: If closure gets fired, it means that 5 seconds has passed, and the attempt is considered as incorrect.
             
             Update incorrect attempts, and check and load next question.
             */
            self?.gameState.value.incorrectAttempts += 1
            self?.checkAndLoadNextRound()
        })
        roundTimer?.start()
    }
    
    /// Resets running timer and creates a new timer for 5 seconds
    func resetRoundTimer() {
        roundTimer?.stop()
        roundTimer?.start()
    }
}
