//
//  AboutViewController.swift
//  Kuggen
//
//  Created by Alexander Nordgren on 2019-04-03.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    
    @IBAction func backButtonTapped(_ sender: Any) {
        coordinator?.start()
    }
}
