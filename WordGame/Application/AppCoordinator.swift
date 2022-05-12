//
//  AppCoordinator.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import Foundation
import UIKit

// MARK: - AppCoordinator

class AppCoordinator: NavigationCoordinator {
    // MARK: - Properties
    
    var navigationController: UINavigationController!
    
    let gameCoordinatorFactory: GameCoordinatorFactory
    
    var gameCoordinator: GameCoordinator?
    
    // MARK: - Lifecycle
    
    init(
        gameCoordinatorFactory: @escaping GameCoordinatorFactory
    ) {
        self.gameCoordinatorFactory = gameCoordinatorFactory
    }
    
    // MARK: - Navigation Methods
    
    func start() {
        gameCoordinator = gameCoordinatorFactory()
        gameCoordinator?.navigationController = navigationController
        gameCoordinator?.parentingCoordinator = self
        gameCoordinator?.start()
    }
}

extension AppCoordinator: GameCoordinatorDelegate {
    func exitApp() {
        exit(-1)
    }
}
