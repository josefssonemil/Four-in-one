//
//  RobotSelectorViewController.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import SpriteKit

class RobotConfigurationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, Storyboarded {
    
    @IBOutlet weak var collectionViewTop: UICollectionView!
    @IBOutlet weak var collectionViewMid: UICollectionView!
    @IBOutlet weak var collectionViewBot: UICollectionView!
    
    var imageArrayTop = [UIImage (named: "Top1"),UIImage (named: "Top2")]
    var imageArrayMid = [UIImage (named: "Mid1"),UIImage (named: "Mid2")]
    var imageArrayBot = [UIImage (named: "Bot1"),UIImage (named: "Bot2")]
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionViewTop.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width
            let itemHeight = collectionViewTop.bounds.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
        if let layout = collectionViewMid.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width
            let itemHeight = collectionViewMid.bounds.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
        if let layout = collectionViewBot.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width
            let itemHeight = collectionViewBot.bounds.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewTop {
            return imageArrayTop.count // Replace with count of your data for collectionViewA
        }else if collectionView == self.collectionViewMid {
            return imageArrayMid.count // Replace with count of your data for collectionViewA
        }
        return imageArrayBot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewTop {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell1.img.image = imageArrayTop[indexPath.row]
            return cell1
        }
        if collectionView == self.collectionViewMid {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell2.img.image = imageArrayMid[indexPath.row]
            return cell2
            }
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell3.img.image = imageArrayBot[indexPath.row]
            return cell3
    }
    
    
    
    weak var coordinator: MainCoordinator?
    
    //Robot
    var team = 0

    @IBOutlet weak var robot1Button: UIButton!
    @IBOutlet weak var robot2Button: UIButton!
    @IBOutlet weak var robot3Button: UIButton!
    @IBOutlet weak var robot4Button: UIButton!
    
    @IBAction func robot1Selected(_ sender: Any) {
        robot1Button.isSelected = true
        robot2Button.isSelected = false
        robot3Button.isSelected = false
        robot4Button.isSelected = false
        team = 1

    }
    
    @IBAction func robot2Selected(_ sender: Any) {
        robot2Button.isSelected = true
        robot1Button.isSelected = false
        robot3Button.isSelected = false
        robot4Button.isSelected = false
        team = 2
    }
    
    
    @IBAction func robot3Selected(_ sender: Any) {
        robot3Button.isSelected = true
        robot2Button.isSelected = false
        robot1Button.isSelected = false
        robot4Button.isSelected = false
        team = 3
    }
    
    @IBAction func robot4Selected(_ sender: Any) {
        robot4Button.isSelected = true
        robot2Button.isSelected = false
        robot3Button.isSelected = false
        robot1Button.isSelected = false
        team = 4

    }
    
    @IBAction func nextTapped(_ sender: Any) {
        coordinator?.goToPairingScreen(team: team)
        // TODO: send robot selected to next screens
        // Also causes a crash due to the pairing phase not being implemented completely yet
    }
    
}
