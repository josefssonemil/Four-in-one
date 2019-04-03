//
//  KuggenSessionServer.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import FourInOneCore
import MultipeerConnectivity


// Subclassing the SessionManager with server-specific behavior

class KuggenSessionServer: KuggenSessionManager {
    
    override public func handleLocal(event: FourInOneEvent, from sender: AnyObject? = nil) {
        
        sendEventToClients(event)
        
    }
    override public func serverHandleRemote(event: FourInOneEvent, from client:MCPeerID) {
        
        
    }
}
