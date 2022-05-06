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
    
    let navigationController: UINavigationController
    
    var parentingCoordinator: GameCoordinatorDelegate?
    
    // MARK: - Lifecycle
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    deinit {
        print(".... GameCoordinator deinitialized")
    }
    
    // MARK: - Navigation Methods
    
    func start() {
        let gameViewController = GameViewController(gameViewModel: GameViewModel())
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
