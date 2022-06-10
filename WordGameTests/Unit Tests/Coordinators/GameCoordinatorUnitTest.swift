//
//  GameCoordinatorUnitTest.swift
//  WordGameTests
//
//  Created by Joel Kingsley on 12/05/2022.
//

import XCTest
import Nimble
@testable import WordGame

class GameCoordinatorUnitTest: XCTestCase {
    var gameCoordinator: GameCoordinator!
    
    let gameContainer = GameContainer(
        parentContainer: AppContainer().container
    )
    
    var mockNavigationController: MockUINavigationController!

    override func setUp() {
        continueAfterFailure = false
        mockNavigationController = MockUINavigationController()
        gameCoordinator = gameContainer.container.resolve(
            GameCoordinator.self)!
        gameCoordinator.navigationController = mockNavigationController
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGameCoordinator_start_forStart_invokesPushViewController() {
        gameCoordinator.start()
        
        expect(self.mockNavigationController.pushViewControllerInvoked).to(equal(true))
    }
}
