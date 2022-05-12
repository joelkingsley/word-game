//
//  MockUINavigationController.swift
//  WordGameTests
//
//  Created by Joel Kingsley on 12/05/2022.
//

import UIKit
import Foundation

class MockUINavigationController: UINavigationController {
    var pushViewControllerInvoked: Bool = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerInvoked = true
    }
}
