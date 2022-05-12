//
//  GameCoordinator.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import Foundation
import UIKit

// MARK: - GameCoordinatorDelegate

protocol GameCoordinatorDelegate: AnyObject {
    func exitApp()
}

// MARK: - GameCoordinator

class GameCoordinator: NavigationCoordinator {
    // MARK: - Properties
    
    var navigationController: UINavigationController!
    
    let gameViewControllerFactory: GameViewControllerFactory
    
    var parentingCoordinator: GameCoordinatorDelegate?
    
    // MARK: - Lifecycle
    
    init(
        gameViewControllerFactory: @escaping GameViewControllerFactory
    ) {
        self.gameViewControllerFactory = gameViewControllerFactory
    }

    // MARK: - Navigation Methods
    
    func start() {
        let gameViewController = gameViewControllerFactory()
        gameViewController.parentingCoordinator = self
        navigationController.pushViewController(gameViewController, animated: true)
    }
}

// MARK: - GameViewControllerDelegate

extension GameCoordinator: GameViewControllerDelegate {
    func exitApp() {
        parentingCoordinator?.exitApp()
    }
}
