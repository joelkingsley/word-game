//
//  MockGetRandomWordPairUseCase.swift
//  WordGameTests
//
//  Created by Joel Kingsley on 12/05/2022.
//

import Foundation
@testable import WordGame

class MockGetRandomWordPairUseCase: GetRandomWordPairUseCase {
    let wordPairRepository: WordPairRepository
    
    var words: [WordPair]?
    
    let probabilityOfWrongWordPair = 0.75
    
    init(
        wordPairRepository: WordPairRepository
    ) {
        self.wordPairRepository = wordPairRepository
    }
    
    func execute() -> Result<WordPair, BusinessError> {
        if words == nil || words?.isEmpty == true,
           let allWords = wordPairRepository.getAllWords(),
           let randomWordPair = allWords.randomElement() {
            return .success(randomWordPair)
        } else {
            return .failure(BusinessErrors.emptyWordList())
        }
    }
}
