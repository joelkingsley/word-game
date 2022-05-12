//
//  WordPairRepositoryImpl.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import Foundation

/**
 Repository to handle operations related to Word Pairs
 */
class WordPairRepositoryImpl: WordPairRepository {
    // MARK: - Properties
    
    private var words: [WordPairDTO]?
    
    // MARK: - Lifecycle
    
    init() {
        self.words = loadWordsFromFile()
    }
    
    // MARK: - Helper Methods
    
    private func loadWordsFromFile() -> [WordPairDTO]? {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([WordPairDTO].self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
            return nil
        }
    }
    
    // MARK: - Methods
    
    func getAllWords() -> [WordPair]? {
        return words?.map({ $0.toEntity() })
    }
}
