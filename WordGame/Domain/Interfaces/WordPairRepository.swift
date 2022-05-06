//
//  WordPairRepository.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import Foundation

/**
 Repository to handle operations related to Word Pairs
 */
protocol WordPairRepository {
    func getAllWords() -> [WordPair]?
}
