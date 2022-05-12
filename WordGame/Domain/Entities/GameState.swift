//
//  GameState.swift
//  WordGame
//
//  Created by Joel Kingsley on 06/05/2022.
//

import Foundation

/**
 Stores the state of the game
 */
struct GameState {
    /// Denotes number of correct attempts
    var correctAttempts = 0
    
    /// Denotes number of incorrect attempts
    var incorrectAttempts = 0
    
    /// Denotes current word pair being displayed
    var currentWordPair: WordPair?
    
    /// Denotes total number of word pairs seen in current game
    var wordPairsSeen: Int = 0
}
