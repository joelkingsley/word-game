//
//  GameFactory.swift
//  WordGame
//
//  Created by Joel Kingsley on 11/05/2022.
//

import Foundation
import Swinject
import UIKit

class GameFactory {
    let gameContainer: Container
    
    init(gameContainer: Container) {
        self.gameContainer = gameContainer
    }
    
    func getGameCoordinatorFactory() -> GameCoordinatorFactory {
        return {
            let gameCoordinator = self.gameContainer.resolve(GameCoordinator.self)!
            return gameCoordinator
        }
    }
    
    func getGameViewControllerFactory() -> GameViewControllerFactory {
        return {
            let gameViewController = GameViewController(gameViewModel: GameViewModel())
            return gameViewController
        }
    }
}

typealias GameCoordinatorFactory = () -> GameCoordinator
typealias GameViewControllerFactory = () -> GameViewController
