//
//  GameViewModelUnitTest.swift
//  WordGameTests
//
//  Created by Joel Kingsley on 12/05/2022.
//

import XCTest
import Nimble
import Combine
@testable import WordGame

class GameViewModelUnitTest: XCTestCase {
    let wordPairRepository = MockWorkPairRepository()
    
    var getRandomWordPairUseCase: MockGetRandomWordPairUseCase!
    
    var gameViewModel: GameViewModel!
    
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        continueAfterFailure = false
        getRandomWordPairUseCase = MockGetRandomWordPairUseCase(
            wordPairRepository: wordPairRepository
        )
        wordPairRepository.setWordList(withWordListScenario: .empty)
        gameViewModel = GameViewModel(
            getRandomWordPairUseCase: getRandomWordPairUseCase
        )
    }

    override func tearDown() {
        wordPairRepository.setWordList(withWordListScenario: .empty)
    }

    func testGameViewModel_init_forInitial_observeInitialGameState() {
        waitUntil { completed in
            self.gameViewModel.gameState.sink { gameState in
                expect(gameState.currentWordPair).to(beNil())
                completed()
                self.cancellables.removeAll()
            }.store(in: &self.cancellables)
        }
    }
    
    func testGameViewModel_setNextRandomWordPair_forOneWordPairWordList_observesOneCorrectCurrentWordPairInGameState()
    {
        wordPairRepository.setWordList(withWordListScenario: .oneWordPair)
        
        var count = 0
        
        waitUntil(timeout: .seconds(5)) { completed in
            self.gameViewModel.gameState.sink { gameState in
                if count == 0 {
                    count += 1
                } else if count == 1 {
                    expect(gameState.currentWordPair).to(equal(
                        WordPair(
                            textEnglish: "primary school",
                            textSpanish: "escuela primaria",
                            isCorrectTranslation: true
                        )
                    ))
                    count += 1
                    self.cancellables.removeAll()
                    completed()
                } else {
                    count += 1
                    fail("Unexpectedly observed another game state: \(count)")
                    completed()
                }
            }.store(in: &self.cancellables)
            
            self.gameViewModel.setNextRandomWordPair()
        }
    }
    
    func testGameViewModel_validateUserResponse_forCorrectSelection_observesCorrectAttemptsIncrementedInGameState() {
        wordPairRepository.setWordList(withWordListScenario: .oneWordPair)
        
        var count = 0
        
        self.gameViewModel.setNextRandomWordPair()
        
        waitUntil { completed in
            self.gameViewModel.gameState.sink { gameState in
                if count == 0 {
                    count += 1
                } else if count == 1 {
                    expect(gameState.correctAttempts).to(equal(1))
                    count += 1
                    self.cancellables.removeAll()
                    completed()
                } else {
                    count += 1
                    fail("Unexpectedly observed another game state: \(count)")
                    completed()
                }
            }.store(in: &self.cancellables)
            
            self.gameViewModel.validateUserResponse(isCorrect: true)
        }
    }
    
    func testGameViewModel_validateUserResponse_forIncorrectSelection_observesIncorrectAttemptsIncrementedInGameState() {
        wordPairRepository.setWordList(withWordListScenario: .oneWordPair)
        
        var count = 0
        
        self.gameViewModel.setNextRandomWordPair()
        
        waitUntil { completed in
            self.gameViewModel.gameState.sink { gameState in
                if count == 0 {
                    count += 1
                } else if count == 1 {
                    expect(gameState.incorrectAttempts).to(equal(1))
                    count += 1
                    self.cancellables.removeAll()
                    completed()
                } else {
                    count += 1
                    fail("Unexpectedly observed another game state: \(count)")
                    completed()
                }
            }.store(in: &self.cancellables)
            
            self.gameViewModel.validateUserResponse(isCorrect: false)
        }
    }
    
    func testGameViewModel_checkAndLoadNextRound_forNotEndOfGame_observeRestartAnimation() {
        wordPairRepository.setWordList(withWordListScenario: .oneWordPair)
        
        var count = 0
        
        self.gameViewModel.setNextRandomWordPair()
        
        waitUntil { completed in
            self.gameViewModel.restartAnimationSubject.sink { _ in
                if count == 0 {
                    count += 1
                    self.cancellables.removeAll()
                    completed()
                } else {
                    count += 1
                    fail("Unexpectedly observed another restart animation: \(count)")
                    completed()
                }
            }.store(in: &self.cancellables)
            
            self.gameViewModel.checkAndLoadNextRound()
        }
    }
    
    func testGameViewModel_checkAndLoadNextRound_forEndOfGame_observePresentGameOverModal() {
        wordPairRepository.setWordList(withWordListScenario: .oneWordPair)
        
        var count = 0
        
        self.gameViewModel.gameState.value = GameState(
            correctAttempts: 15,
            incorrectAttempts: 0,
            currentWordPair: nil,
            wordPairsSeen: 15
        )
        
        waitUntil { completed in
            self.gameViewModel.presentGameOverModalSubject.sink { _ in
                if count == 0 {
                    count += 1
                    self.cancellables.removeAll()
                    completed()
                } else {
                    count += 1
                    fail("Unexpectedly observed another restart animation: \(count)")
                    completed()
                }
            }.store(in: &self.cancellables)
            
            self.gameViewModel.checkAndLoadNextRound()
        }
    }
    
    func testGameViewModel_initializeAndStartRoundTimer_forInitializing_shouldInitializeRoundTimer() {
        self.gameViewModel.gameState.value = GameState(
            correctAttempts: 15,
            incorrectAttempts: 0,
            currentWordPair: nil,
            wordPairsSeen: 15
        )
        
        waitUntil { completed in
            self.gameViewModel.initializeAndStartRoundTimer(timePerRoundInSeconds: 0)
            
            if let roundTimer = self.gameViewModel.roundTimer {
                roundTimer.fireHandler()
                expect(roundTimer).toNot(beNil())
                completed()
            } else {
                fail("Unexpectedly found roundTimer to be nil")
                completed()
            }
        }
    }
}
