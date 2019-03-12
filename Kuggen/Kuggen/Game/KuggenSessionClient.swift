//
//  KuggenSessionClient.swift
//  Kuggen
//

import UIKit
import FourInOneCore
import MultipeerConnectivity



protocol KuggenSessionManagerDelegate : FourInOneSessionManagerDelegate {
    
    func gameManager(_ manager: KuggenSessionManager, moveMid newCenter: CGPoint, deviceAt position:DevicePosition)
    
    func gameManagerGameOver(_ manager: KuggenSessionManager)
    

    func gameManagerNextLevel(_ manager:KuggenSessionManager)
    
}

class KuggenSessionClient: KuggenSessionManager {
    
}
