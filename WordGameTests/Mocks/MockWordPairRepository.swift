//
//  MockWordPairRepository.swift
//  WordGameTests
//
//  Created by Joel Kingsley on 08/05/2022.
//

import Foundation
@testable import WordGame

class MockWorkPairRepository: WordPairRepository {
    // MARK: - Properties
    
    static let sharedInstance = MockWorkPairRepository()
    
    private var words: [WordPairDTO]?
    
    // MARK: - Helper Methods
    
    func setWordList(withWordListScenario wordListScenario: WordListScenario) {
        switch wordListScenario {
        case .empty:
            self.words = []
        case .oneWordPair:
            self.words = [
                WordPairDTO(
                    textEnglish: "primary school",
                    textSpanish: "escuela primaria"
                )
            ]
        case .twoWordPairs:
            self.words = [
                WordPairDTO(
                    textEnglish: "teacher",
                    textSpanish: "profesor / profesora"
                ),
                WordPairDTO(
                    textEnglish: "pupil",
                    textSpanish: "alumno / alumna"
                ),
            ]
        case .moreThanTwoWordPairs:
            self.words = [
                WordPairDTO(
                    textEnglish: "primary school",
                    textSpanish: "escuela primaria"
                ),
                WordPairDTO(
                    textEnglish: "teacher",
                    textSpanish: "profesor / profesora"
                ),
                WordPairDTO(
                    textEnglish: "pupil",
                    textSpanish: "alumno / alumna"
                ),
            ]
        }
    }
    
    // MARK: - Methods
    
    func getAllWords() -> [WordPair]? {
        return words?.map({ $0.toEntity() })
    }
}

// MARK: - WordListScenario

enum WordListScenario {
    case empty
    case oneWordPair
    case twoWordPairs
    case moreThanTwoWordPairs
}
