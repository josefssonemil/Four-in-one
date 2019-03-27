//
//  MenuViewController.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    
    @IBAction func nextTapped(_ sender: Any) {
        coordinator?.goToTeamSelection()
    }
}
