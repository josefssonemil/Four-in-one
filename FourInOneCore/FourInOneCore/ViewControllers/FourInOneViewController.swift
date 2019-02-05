//
//  FourInOneViewController.swift
//  4in1Setup
//
//  Created by Olof Torgersson on 2017-10-05.
//  Copyright © 2017 Olof Torgersson. All rights reserved.
//

import UIKit

/**
 
 The FourInOneCore framework is currently design to handle apps running in fullscreen landscape only. A
 FourInOneNavigationController working together with a FourInOneViewController implements that apps do not rotate the screen. It is recommended to use a FourInOneNavigationController for managing the navigation in the app and to let view controllers except for a possible start/menu screen be subclasses of FourInOneViewController.
 */
open class FourInOneViewController: UIViewController {

    /*
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
*/
    
    /** Returns false to prevent auto rotation. */
    override open var shouldAutorotate: Bool {
        
        return false
        
    }
    
    /** Returns  UIInterfaceOrientationMask.landscape. */
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.landscape
    }
    
    /*
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
