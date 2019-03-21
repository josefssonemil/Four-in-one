//
//  RobotSelectorViewController.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

//TODO: Clean up code and make the selections save somewhere. Also update the view to be more usable.
import UIKit
import SpriteKit

class RobotConfigurationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, Storyboarded {
    
    @IBOutlet weak var collectionViewTop: UICollectionView!
    @IBOutlet weak var collectionViewMid: UICollectionView!
    @IBOutlet weak var collectionViewBot: UICollectionView!

    
    // array of path to the selected robot configuration, might not be needed
    var selected = [IndexPath(item: 1, section: 0),IndexPath(item: 0, section: 0),IndexPath(item: 0, section: 0)]
    // arrays of images that will be used to select different configurations.
    var imageArrayTop = [UIImage (named: "Top1"),UIImage (named: "Top2")]
    var imageArrayMid = [UIImage (named: "Mid1"),UIImage (named: "Mid2")]
    var imageArrayBot = [UIImage (named: "Bot1"),UIImage (named: "Bot2")]
   
    //TODO: Save the configuration.
    //save button pressed. returns to main menu and saves the configuration.
    @IBAction func saveTapped(_ sender: UIButton) {
        selected[0] = collectionViewTop.indexPathsForVisibleItems.first as! IndexPath
        selected[1] = collectionViewMid.indexPathsForVisibleItems.first as! IndexPath
        selected[2] = collectionViewBot.indexPathsForVisibleItems.first as! IndexPath
        print(selected)
        coordinator?.start()
    }
    // Sets the layout for the collectionsViews
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

    //number of items in eaxh collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewTop {
            return imageArrayTop.count // Replace with count of your data for collectionViewA
        }else if collectionView == self.collectionViewMid {
            return imageArrayMid.count // Replace with count of your data for collectionViewA
        }
        return imageArrayBot.count
    }
    
    //sets the images to each collectionView
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
    //TODO : should set the showing images to correspond to the current robot configuration.
    override func viewDidLoad() {
        print(selected)
    collectionViewTop.scrollToItem(at: selected[0] as IndexPath, at: .right, animated: true)
    collectionViewMid.scrollToItem(at: selected[1] as IndexPath, at: .right, animated: true)
    collectionViewBot.scrollToItem(at: selected[2] as IndexPath, at: .right, animated: true)
    }
 
    // Old code
    weak var coordinator: MainCoordinator?
    
    //Robot (not needed)
    //var team = 0
/*
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
        coordinator?.goToPairingScreen()
        // TODO: send robot selected to next screens
        // Also causes a crash due to the pairing phase not being implemented completely yet
    }*/
    
}
