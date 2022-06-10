//
//  GetRandomWordPairUseCaseUnitTest.swift
//  WordGameTests
//
//  Created by Joel Kingsley on 08/05/2022.
//

import XCTest
import Nimble
@testable import WordGame

class GetRandomWordPairUseCaseUnitTest: XCTestCase {
    
    var mockWordPairRepository: MockWorkPairRepository!

    override func setUp() {
        continueAfterFailure = false
        mockWordPairRepository = MockWorkPairRepository()
        mockWordPairRepository.setWordList(withWordListScenario: .empty)
    }

    override func tearDown() {
        mockWordPairRepository.setWordList(withWordListScenario: .empty)
    }

    func testGetRandomWordPairUseCase_forEmptyWordList_returnsError() {
        let getRandomWordPairUseCase = GetRandomWordPairUseCaseImpl(wordPairRepository: mockWordPairRepository)
        mockWordPairRepository.setWordList(withWordListScenario: .empty)
        
        let randomWordPair = getRandomWordPairUseCase.execute()
        
        switch randomWordPair {
        case let .success(wordPair):
            fail("Unexpectedly got word pair: \(wordPair)")
        case let .failure(error):
            expect(error).to(beAKindOf(BusinessErrors.emptyWordList.self))
        }
    }
    
    func testGetRandomWordPairUseCase_forOneWordPair_returnsSameCorrectWordPairAlways() {
        let getRandomWordPairUseCase = GetRandomWordPairUseCaseImpl(wordPairRepository: mockWordPairRepository)
        mockWordPairRepository.setWordList(withWordListScenario: .oneWordPair)
        
        let randomWordPair = getRandomWordPairUseCase.execute()
        
        switch randomWordPair {
        case let .success(wordPair):
            expect(wordPair)
                .to(equal(
                    WordPair(
                        textEnglish: "primary school",
                        textSpanish: "escuela primaria",
                        isCorrectTranslation: true
                    ))
                )
        case let .failure(error):
            fail("Unexpectedly got error: \(error)")
        }
    }
    
    func testGetRandomWordPairUseCase_forTwoWordPairs_returnsAtleastOneIncorrectWordPairForTwoRounds() {
        let getRandomWordPairUseCase = GetRandomWordPairUseCaseImpl(wordPairRepository: mockWordPairRepository)
        mockWordPairRepository.setWordList(withWordListScenario: .twoWordPairs)
        
        let randomWordPair1 = getRandomWordPairUseCase.execute()
        let randomWordPair2 = getRandomWordPairUseCase.execute()
        
        switch randomWordPair1 {
        case let .success(wordPair1):
            if wordPair1.isCorrectTranslation {
                switch randomWordPair2 {
                case let .success(wordPair2):
                    expect(wordPair2.isCorrectTranslation)
                        .to(equal(false))
                case let .failure(error):
                    fail("Unexpectedly got error: \(error)")
                }
            }
        case let .failure(error):
            fail("Unexpectedly got error: \(error)")
        }
    }
    
    func testGetRandomWordPairUseCase_forMoreThanTwoWordPairs_returnsValidWordPairsAtleastThreeTimes() {
        let getRandomWordPairUseCase = GetRandomWordPairUseCaseImpl(wordPairRepository: mockWordPairRepository)
        mockWordPairRepository.setWordList(withWordListScenario: .moreThanTwoWordPairs)
        
        let randomWordPair1 = getRandomWordPairUseCase.execute()
        let randomWordPair2 = getRandomWordPairUseCase.execute()
        let randomWordPair3 = getRandomWordPairUseCase.execute()
        
        expect(randomWordPair1).to(beSuccess())
        expect(randomWordPair2).to(beSuccess())
        expect(randomWordPair3).to(beSuccess())
    }

}
