//
//  GetRandomWordPairUseCase.swift
//  WordGame
//
//  Created by Joel Kingsley on 06/05/2022.
//

import Foundation

/**
 Use Case to get a random word pair with a 25% probability of it being correct
 */
class GetRandomWordPairUseCase {
    let wordPairRepository: WordPairRepository
    
    var words: [WordPair]?
    
    let probabilityOfWrongWordPair = 0.75
    
    init(
        wordPairRepository: WordPairRepository
    ) {
        self.wordPairRepository = wordPairRepository
    }
}

extension GetRandomWordPairUseCase {
    func execute() -> Result<WordPair, Error> {
        /**
         Load all words from file and set correct and wrong translations
         */
        if words == nil || words?.isEmpty == true,
           let allWords = wordPairRepository.getAllWords()
        {
            /**
             Only determine wrong word pairs if there is more than 1 word pair in repository
             */
            if allWords.count > 1 {
                /**
                 Determine set of indices that should have wrong word pairs
                 */
                let numberOfWrongWordPairs = Int(Float(allWords.count)*Float(probabilityOfWrongWordPair))
                var set = Set<Int>()
                while set.count < numberOfWrongWordPairs {
                    set.insert(Int.random(in: 0..<allWords.count))
                }
                
                /**
                 Replace the spanish text of the word pairs determined to be set to wrong to a different text
                 */
                var updatedWords = allWords
                set.forEach { index in
                    let remainingIndices = Array(0..<allWords.count).filter({ $0 != index })
                    let replacingWordPairIndex = remainingIndices.randomElement()!
                    updatedWords[index] = WordPair(
                        textEnglish: updatedWords[index].textEnglish,
                        textSpanish: allWords[replacingWordPairIndex].textSpanish,
                        isCorrectTranslation: false
                    )
                }
                words = updatedWords
            } else {
                words = allWords
            }
        }
        guard var words = words else {
            return .failure(NSError(domain: "Not Found", code: 404, userInfo: nil))
        }
        
        // Random key from array
        let arrayKey = Int(arc4random_uniform(UInt32(words.count)))

        // Random word pair
        let randomWordPair = words[arrayKey]

        // Make sure the word pair is not repeated
        words.swapAt(arrayKey, words.count-1)
        words.removeLast()
        
        return .success(randomWordPair)
    }
}
