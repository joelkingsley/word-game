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
    
    let navigationController: UINavigationController
    
    var gameCoordinator: GameCoordinator?
    
    // MARK: - Lifecycle
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    deinit {
        print(".... AppCoordinator deinitialized")
    }
    
    // MARK: - Navigation Methods
    
    func start() {
        gameCoordinator = GameCoordinator(navigationController: navigationController)
        gameCoordinator?.parentingCoordinator = self
        gameCoordinator?.start()
    }
}

extension AppCoordinator: GameCoordinatorDelegate {
    func exitApp() {
        exit(-1)
    }
}
