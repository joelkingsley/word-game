//
//  GameViewModelIntegrationTest.swift
//  WordGameTests
//
//  Created by Joel Kingsley on 08/05/2022.
//

import XCTest
import Nimble
@testable import WordGame

class GameViewModelIntegrationTest: XCTestCase {

    let gameViewModel = GameViewModel()
    
    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {
    }

    func testGameViewModel_getRandomWordPairMethod_withActualWordFile_returnsValidWordPair() {
        expect(self.gameViewModel.getRandomWordPairUseCase.execute()).to(beSuccess())
    }
    
    func testGameViewModel_validateUserResponseMethod_withCurrentWordPairSet_returnsBool() {
        gameViewModel.gameState.currentWordPair = WordPair(
            textEnglish: "primary school",
            textSpanish: "escuela primaria",
            isCorrectTranslation: true
        )
        expect(self.gameViewModel.validateUserResponse(isCorrect: true)).to(beSuccess())
    }
    
    func testGameViewModel_validateUserResponseMethod_withCurrentWordPairNotSet_returnsError() {
        gameViewModel.gameState.currentWordPair = nil
        switch gameViewModel.validateUserResponse(isCorrect: true) {
        case let .failure(error):
            expect(error).to(beAKindOf(BusinessErrors.clientError.self))
        case let .success((correctAttempts, incorrectAttempts)):
            fail("Unexpectedly got correctAttempts and incorrectAttempts: \(correctAttempts) and \(incorrectAttempts)")
        }
    }
}

