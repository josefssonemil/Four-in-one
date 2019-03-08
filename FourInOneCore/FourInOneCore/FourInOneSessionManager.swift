//
//  FourInOneSessionManager.swift
//  FourInOneCore
//
//  Created by Olof Torgersson on 2017-11-16.
//  Copyright © 2017 Olof Torgersson. All rights reserved.
//

import Foundation
import MultipeerConnectivity

/**
 The `FourInOneSessionManagerDelegate` protocol defines the methods that a delegate
 of a `FourInOneSessionManager` must implement. The protocol defines only the most basic
 behaviour and it is expected that subclasses of FourInOneSessionManager need to
 extend it.
 */
public protocol FourInOneSessionManagerDelegate {
    
    /// Invoked when a session loses a peer. Since there is currently no mechanism for
    /// recovering it is likely that the receiver needs to cancel the ongoing session.
    /// - parameter manager: The set up manager providing this information.
    func sessionManager(_ manager: FourInOneSessionManager, lostPeer:MCPeerID)
    
}

/**
 The FourInOneSessionManager class implements the basic functionality for a 4-in-1 session.
 This basic functionality is to send and receive `FourInOneEvent` objects between the participants
 in a session. Since the class does not contain and specific knowledge about the needs of
 any particualr 4-in-1 application it needs to be subclassed to provide the details in each
 specific case. The design of the FourInOneCore assumes that one device acts as s server controlling a session.
 A suitable approach could therefore be to define an application specific subclass with
 general functionality and to further subclass this into a client and server class to simplify
 implementing each of these roles. However, this is not a requirement.
 
 Subclassing `FourInOneSessionManager` is likely to mean that the `FourInOneSessionManagerDelegate` protocol needs to be extended. This leads to a typing problem since it is not possible to change the delegate property to say that it adheres to this extended protocol.
 
 The best solution found so far is to do the following:
 ````
 // Extend the protocol
 protocol SubClassManagerDelegate : FourInOneSessionManagerDelegate {
 
    func subClassDelegateMethod(_ manager: SubClassSessionManager)
 ...
 
 }

 class SubClassSessionManager {
 
 ...
 
    //override public var delegate : FourInOneSessionManagerDelegate
    var subClassDelegate: SubClassManagerDelegate?
 
    override public var delegate: FourInOneSessionManagerDelegate? {
        get { return subClassDelegate }
        set { subClassDelegate = newValue as! SubClassManagerDelegate? }
 }
 
 ...
 
 // Calling delegate
    subClassDelegate?.subClassDelegateMethod(self)
 }
 
 // Usage
 class someClass : SubClassManagerDelegate {
 
    var manager = SubClassSessionManager()
    manager.delegate = self
 
 }
 ````
 */
open class FourInOneSessionManager: NSObject, MCSessionDelegate {
    
    // MARK: Properties
    
    /// Set this to the `Platform`value used to draw content in the session.
    /// The default value is `Platform.uikit`
    public var platform : Platform
    
    /// Defines whether data should be sent using the reliable or unreliable `MCSessionSendDataMode`.
    /// Using the relaible mode guarantees that messages are delivered and arrive order at the expense
    /// of efficiency.
    public var sendDataMode: MCSessionSendDataMode
    
    /** The peer id representing this device in a session.*/
    public var peerId: MCPeerID!
    
    /** The session object managing the 4-in-1 session.*/
    public var session: MCSession!
 
    /** The peer id reperesenting the device acting as server in the session.*/
    public var server: MCPeerID?
    
    /** Information about the clients connected to a session*/
    public var clients: [PeerInfo]

    /** The mode (number of participants) in the session. */
    public var mode: GameMode
    
    /** The position of this device */
    public var position: DevicePosition
    
    /** The team used in this session. The default value is 0 */
    public var team : Int
    
    /** Whether this device acts as server or not. */
    public var isServer: Bool
    
    /** Whether the session is active or not. The session only sends events to peers when it is active*/
    private var isActive: Bool
    
    /// The session delagate. Typically sublasses of `FourIneOneSessionManager`need to extend the
    /// `FourInOneSessionManagerDelegate``to handle application specific events.
    open var delegate : FourInOneSessionManagerDelegate?
    
    // MARK: - Initializers

    /** Creates a new set up manager. */
    public override init() {
        
        // These are not really needed
        // but are just here to hide initial values
        self.platform = .uikit
        self.sendDataMode = .reliable
        self.clients = []
        self.mode = .singleplayer
        self.position = .one
        self.team = 0
        self.isServer = false
        self.server = MCPeerID(displayName: UIDevice.current.name)
        self.isActive = false
        
        super.init()
        
    }
    
    // MARK: - Starting and stopping

    /// Starts the session. This method should be called before any other other
    /// methods like sending data are used.
    open func startSession() {
        
        session.delegate = self
        isActive = true
        
    }
    
    /// Pauses the session. This means that no messages  are sent to peers.
    open func pauseSession() {
        
        isActive = false
        
    }
    
    /// Stops the session and disconnects from the underlying `MCSession`.
    /// It is important to call this methods leaves a session to make sure the
    /// that the connection to the underlying session ends.
    open func stopSession() {
        
        isActive = false
        session.delegate = nil
        session.disconnect()
        
    }
    
    
    // MARK: - Handling events
    
    /// Informs the session manager that an event has occurred in the application on
    /// this device that needs to be handled and communicated within the session.
    /// The default implementation calls `handleLocal(event:from:)` if this device acts as
    /// server and simply sends it to the server otherwise.
    /// - parameter event: The event to handle.
    /// - parameter sender: The object that sent the event.
    public func local(event: FourInOneEvent, from sender: AnyObject? = nil) {
        
        // client send to server
        // server anropa lämplig tom metod
        if isActive {
            
            if isServer {
                
                handleLocal(event: event, from: sender)
            }
            else {
                
                sendEventToServer(event)
                
            }
        }
        
    }
    
    /// Defines how the session manager handles a `FourInOneEvent`that originated on the
    /// device that the session manager is running on. The default implementation is empty.
    /// - parameter event: The event to handle.
    /// - parameter sender: The object that sent the event.
    open func handleLocal(event: FourInOneEvent, from sender: AnyObject? = nil) {
        
    }
    
    /// Informs the session manager that the application has received an event that
    /// originated on another device in the session. The event is simply forwarded to
    /// the method `serverHandleRemote(event:from:)` or the method
    /// `clientHandleRemote(event:from)` depending on if this device acts as server or not.
    /// - parameter event: The event to handle.
    /// - parameter sender: The peer that sent the event.
    public func remote(event: FourInOneEvent, fromPeer peerID: MCPeerID) {
        
        // server anropa lämplig tom metod som hanterar och skickar vidare
        // client lämplig tom metod som hanterar
        if isActive {
            
            if isServer {
                
                serverHandleRemote(event: event, from: peerID)
                
            }
            else {
                
                clientHandleRemote(event: event, from: peerID)
                
            }
        }
        
    }
    
    /// Defines how a session manager acting as server handles a `FourInOneEvent`that originated on
    /// another device. The default implementation is empty.
    /// - parameter event: The event to handle.
    /// - parameter sender: The peer that sent the event.
    open func serverHandleRemote(event: FourInOneEvent, from client:MCPeerID) {
        
    }
    
    /// Defines how a session manager acting as client handles a `FourInOneEvent`that originated on
    /// another device. The default implementation is empty.
    /// - parameter event: The event to handle.
    /// - parameter sender: The peer that sent the event.
    open func clientHandleRemote(event: FourInOneEvent, from server:MCPeerID) {
        
    }
    
    
    // MARK: - Sending events

    /// Sends a `FourInOneEvent` to the server. This methods is only meaningful for clients.
    /// - parameter event: The event to send to the server.
    public func sendEventToServer(_ event:FourInOneEvent) {
        
        if let server = server {
            
            send(event:event, to: server)
            
        }
    }
    
    /// Sends a `FourInOneEvent` to the clients. This methods is only meaningful for the server.
    /// The purpose of the possibility to exclude a peer is that it might not be useful to send an event
    /// back to the client that sent it.
    /// - parameter event: The event to send to the clients.
    /// - parameter event: The peer that should not receive the event.
    public func sendEventToClients(_ event: FourInOneEvent, exluding peer:MCPeerID) {
        
        for client in clients {
            
            if client.peer != peer {
                
                send(event: event, to: client.peer)
                
            }
        }
        
    }
    
    /// Sends a `FourInOneEvent` to all clients. This methods is only meaningful for the server.
    /// - parameter event: The event to send to the clients.
    public func sendEventToClients(_ event: FourInOneEvent) {
        
        for client in clients {
            
            send(event: event, to: client.peer)
            
        }
        
    }
    
    /// Sends a `FourInOneEvent` to a specific peer. This methods is only meaningful for the server.
    /// - parameter event: The event to send to the client.
    /// - parameter peer: The peer representing the client.
    public func send(event: FourInOneEvent, to peer:MCPeerID) {
        
        let encoder = JSONEncoder()
        
        //print("send: \(event)")
        
        if let messageData = try? encoder.encode(event) {
            
            do {
                
                try session.send(messageData, toPeers: [peer], with: sendDataMode)
            }
            catch {
                
                print("sending data to \(peer.displayName) failed")
            }
            
        }
    }
    
    // MARK: - Utilities

    /// Returns the position of peer in the current session or nil if it is not connected.
    /// - parameter peer: The peer to find the position for.
    public func positionOf(peer: MCPeerID) -> DevicePosition? {
        
        for client in clients {
            
            if client.peer == peer {
                
                return client.position
                
            }
        }
        return nil
        
    }
    
    struct DeviceSize {
        
        static let width = 1024
        static let height = 768
        static let frameX = 114
        static let frameY = 57
        
    }
    
    /// Returns the size of the virtual space cretaed by all the devices involved in the session
    public func makeBoardSize() -> CGSize {
        
        var boardWidth = DeviceSize.width
        var boardHeight = DeviceSize.height*2+DeviceSize.frameY*2
        
        if mode == .fourplayer {
       
            boardWidth = DeviceSize.width*2+DeviceSize.frameX*2
            
        }
        else if mode == .singleplayer {
            
            boardHeight = DeviceSize.height
            
        }

        return CGSize(width: boardWidth, height: boardHeight)
        
    }
    
    let deltaX = DeviceSize.width + 2*DeviceSize.frameX
    let deltaY = DeviceSize.height + 2*DeviceSize.frameY
    
    // Should work regardless of if it's 2 or four devices since for 2 devices
    // positions one and 2 are used
    
    /// Translates from the coordinate system of the current device into
    /// the coordinate system of the combined virtual space.
    /// - parameter local: A point in the local coordinate system.
    public func makeGlobal(_ local:CGPoint) -> CGPoint {
        
        var global = CGPoint()
        
        switch platform {
            
        case .uikit:
            
            switch position {
                
            case .one:
                global.x = local.x
                global.y = local.y + CGFloat(deltaY)
            case .two:
                global.x = local.x
                global.y = local.y
            case .three:
                global.x = local.x + CGFloat(deltaX)
                global.y = local.y
            case .four:
                global.x = local.x + CGFloat(deltaX)
                global.y = local.y + CGFloat(deltaY)
                
            }
            
        case .spritekit:
            
            switch position {
                
            case .one:
                global.x = local.x
                global.y = local.y
            case .two:
                global.x = local.x
                global.y = local.y + CGFloat(deltaY)
            case .three:
                global.x = local.x + CGFloat(deltaX)
                global.y = local.y + CGFloat(deltaY)
            case .four:
                global.x = local.x + CGFloat(deltaX)
                global.y = local.y
                
            }
            
        }
        
        return global
    }
    
    /// Translates from the coordinate system of the combined virtual space
    /// into local coordinate system.
    /// - parameter global: A point in the global coordinate system.
    public func makeLocal(_ global:CGPoint) -> CGPoint {
        
        var local = CGPoint()
        
        switch platform {
            
        case .uikit:
            
            switch position {
            case .one:
                local.x = global.x
                local.y = global.y - CGFloat(deltaY)
            case .two:
                local.x = global.x
                local.y = global.y 
            case .three:
                local.x = global.x - CGFloat(deltaX)
                local.y = global.y
            case .four:
                local.x = global.x - CGFloat(deltaX)
                local.y = global.y - CGFloat(deltaY)
            }
            
        case .spritekit:
            
            switch position {
            case .one:
                local.x = global.x
                local.y = global.y
            case .two:
                local.x = global.x
                local.y = global.y - CGFloat(deltaY)
            case .three:
                local.x = global.x - CGFloat(deltaX)
                local.y = global.y - CGFloat(deltaY)
            case .four:
                local.x = global.x - CGFloat(deltaX)
                local.y = global.y
            }
            
        }
        
        return local
    }
    
    /// Returns the center of a `CGRect`
    public func center(rect:CGRect) -> CGPoint {
        
        var point = CGPoint()
        point.x = rect.midX
        point.y = rect.midY
        
        return point
        
    }
    
    // MARK: - MCSessionDelegate
    
    /// Called by the underlying `MCSession` when a peer changes connection state.
    /// If the connection is lost the delegate is informed through the method
    /// `sessionManager(lostPeer:)`. Since there is no support for reconnecting to the session
    /// the likely respones of the delegate is to end the session.
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        print("peer \(peerID) didChangeState: \(state)")
        
        if (state == .notConnected) {
            
            OperationQueue.main.addOperation {

            self.delegate?.sessionManager(self, lostPeer: peerID)
                
            }
            
        }
        
    }
    
    /// Called by the underlying `MCSession` when data is received.
    /// The session manager creates an event from the data and calls `remote(event:fromPeer:)`.
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        do {
            
            let receivedEvent = try JSONDecoder().decode(FourInOneEvent.self, from: data)
            
            // print("receive: \(receivedEvent)")
            
            remote(event: receivedEvent, fromPeer: peerID)
            
        }
        catch {
            
            print("FourInOneSessionManager error decoding \(data), \(error)")
        }
    }
    
    /// Does nothing currently.
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    /// Does nothing currently.
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    /// Does nothing currently.
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
}

