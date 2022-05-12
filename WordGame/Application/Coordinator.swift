//
//  Coordinator.swift
//  WordGame
//
//  Created by Joel Kingsley on 05/05/2022.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController! { get }
}
