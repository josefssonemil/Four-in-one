//
//  MainCoordinator.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    
    // Child coordinators are only used if scaling issues occur
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Starting the application
    func start() {
        let vc = MenuViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    
    func goToRobotSelection(){
        let vc = RobotSelectorViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToPairingScreen(){
        let vc  = PairingViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToGameScreen(){
        let vc = GameViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    
}
