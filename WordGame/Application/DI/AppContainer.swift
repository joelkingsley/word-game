//
//  AppContainer.swift
//  WordGame
//
//  Created by Joel Kingsley on 11/05/2022.
//

import Foundation
import Swinject

class AppContainer {
    let container: Container
    
    let gameContainer: GameContainer
    
    init() {
        self.container = Container()
        self.gameContainer = GameContainer(parentContainer: container)
        
        container.register(AppCoordinator.self, factory: { res in
            let gameFactory = self.gameContainer.container.resolve(GameFactory.self)!
            return AppCoordinator(
                gameCoordinatorFactory: gameFactory.getGameCoordinatorFactory()
            )
        })
        
        container.register(WordPairRepositoryImpl.self) { res in
            WordPairRepositoryImpl()
        }
    }
}
