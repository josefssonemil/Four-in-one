//
//  MainCoordinator.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import FourInOneCore

class MainCoordinator: Coordinator {
    
    // Child coordinators are only used if scaling issues occur
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Starting the application
    func start() {
        let vc = PreMainMenuViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToMainMenu() {
        let vc = MenuViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToRobotSelection(){
        let vc = RobotConfigurationViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToTeamSelection(){
        let vc  = TeamSelectionViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)

    }
    
    func goToAlignmentScreen(team: Int){
        let vc = AlignmentViewController.instantiate()
        vc.coordinator = self
        vc.team = team
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToGameScreen(gameManager: KuggenSessionManager){
        let vc = GameViewController.instantiate()
        vc.coordinator = self
        vc.sessionManager = gameManager
        navigationController.pushViewController(vc, animated: false)
    }
    func goToOptionsView(){
        let vc = OptionsViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}
