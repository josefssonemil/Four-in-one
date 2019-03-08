//
//  FourInOneBavigationController.swift
//  4in1Setup
//
//  Created by Olof Torgersson on 2017-10-04.
//  Copyright © 2017 Olof Torgersson. All rights reserved.
//

import UIKit

/**
 
 The FourInOneCore framework is currently design to handle apps running in fullscreen landscape only. A
 FourInOneNavigationController working together with a FourInOneViewController implements that apps do not rotate the screen. It is recommended to use a FourInOneNavigationController for managing the navigation in the app and to let view controllers except for a possible start/menu screen be subclasses of FourInOneViewController.
 */
public class FourInOneNavigationController: UINavigationController {
 
    /** Allows rotation if the visible view controller allows rotation.*/
    override public var shouldAutorotate: Bool {
        
        if let visibleController = visibleViewController  {
            
            return visibleController.shouldAutorotate
            
        }
        return true
        
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        /** Returns the orientations supported by the visible view controller.*/
        if let visibleController = visibleViewController {
            
            return visibleController.supportedInterfaceOrientations
            
        }
        return UIInterfaceOrientationMask.all
    }

}
