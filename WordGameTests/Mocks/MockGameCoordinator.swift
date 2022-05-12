//
//  MockGameCoordinator.swift
//  WordGameTests
//
//  Created by Joel Kingsley on 12/05/2022.
//

import Foundation
@testable import WordGame

class MockGameCoordinator: GameCoordinator {
    var coordinatorStarted: Bool = false
    
    override func start() {
        coordinatorStarted = true
    }
}
