//
//  AppCoordinatorUnitTest.swift
//  WordGameTests
//
//  Created by Joel Kingsley on 12/05/2022.
//

import XCTest
import Nimble
@testable import WordGame

class AppCoordinatorUnitTest: XCTestCase {
    var gameCoordinatorFactory: GameCoordinatorFactory!
    
    var mockGameCoordinator: MockGameCoordinator!
    
    var appCoordinator: AppCoordinator!
    
    let gameContainer = GameContainer(
        parentContainer: AppContainer().container
    )

    override func setUp() {
        continueAfterFailure = false
        let gameFactory = gameContainer.container.resolve(GameFactory.self)!
        mockGameCoordinator = MockGameCoordinator(
            gameViewControllerFactory: gameFactory.getGameViewControllerFactory()
        )
        gameCoordinatorFactory = {
            let gameCoordinator = self.mockGameCoordinator!
            return gameCoordinator
        }
        appCoordinator = AppCoordinator(
            gameCoordinatorFactory: gameCoordinatorFactory
        )
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAppCoordinator_start_forStart_invokesGameCoordinatorStart() {
        appCoordinator.start()
        
        expect(self.mockGameCoordinator.coordinatorStarted).to(equal(true))
    }
}
