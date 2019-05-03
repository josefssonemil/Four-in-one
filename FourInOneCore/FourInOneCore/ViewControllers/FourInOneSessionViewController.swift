//
//  FourInOneSessionViewController.swift
//  FourInOneCore
//
//  Created by Olof Torgersson on 2017-12-10.
//  Copyright © 2017 Olof Torgersson. All rights reserved.
//

import UIKit

/**
 
 A `FourInOneSessionViewController` handles a few basic behaviours of view controllers involved in 4-in-1 sessions. The visible contents should be dsiplayed in the `boardView`, and the
 session is managed by the `sessionManager`. To form a virtual area of all involved devices the boardView is rotated 180 degrees in position 2 and 3.
 */
open class FourInOneSessionViewController: FourInOneViewController {

    /// The view containing the shared 4-in-1 space.
    /// This view is rotated 180 degrees for devices in position 2 and 3.
    @IBOutlet weak public var boardView: UIView!

    /// The sized of the combined size of all involved devices.
    /// This area is made up of all area och each device's screen plus
    /// additional space for the borders between the different screens.
    public var globalSize = CGSize()

    /// The object managing the underlying multi peer connectivity session.
    public var sessionManager : FourInOneSessionManager!
    
    /// Sets `globalSize` and rotates `boardView` when needed.
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let position = sessionManager.position
        
        if  position == .four || position == .three {
            
            self.boardView.transform = self.boardView.transform.rotated(by:.pi)
            
        }
        globalSize = sessionManager.makeBoardSize()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
