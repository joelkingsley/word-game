//
//  GameContainer.swift
//  WordGame
//
//  Created by Joel Kingsley on 11/05/2022.
//

import Foundation
import Swinject

class GameContainer {
    let container: Container
    
    init(parentContainer: Container) {
        self.container = Container(parent: parentContainer)
        
        container.register(GameFactory.self) { res in
            GameFactory(gameContainer: self.container)
        }
        
        container.register(GameCoordinator.self) { res in
            let gameFactory = self.container.resolve(GameFactory.self)!
            return GameCoordinator(
                gameViewControllerFactory: gameFactory.getGameViewControllerFactory()
            )
        }
    }
}
