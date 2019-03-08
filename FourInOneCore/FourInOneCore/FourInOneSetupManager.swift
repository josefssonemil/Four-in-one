//
//  FourInOneSessionManager.swift
//  4in1Setup
//
//  Created by Olof Torgersson on 2017-09-22.
//  Copyright © 2017 Olof Torgersson. All rights reserved.
//

import Foundation
import MultipeerConnectivity

/**
 The `FourInOneSetupManagerDelegate` protocol defines the methods that a delegate
 of a FourInOneSetupManager must implement.
 */
public protocol FourInOneSetupManagerDelegate  {
    
    /// Invoked when a set up session is started.
    /// - parameter manager: The set up manager providing this information.
    func setupManagerDidStartSession(_ manager: FourInOneSetupManager)
    
    /// Invoked when a set up session is cancelled.
    /// - parameter manager: The set up manager providing this information.
    func setupManagerDidCancel(_ manager: FourInOneSetupManager)
    
    /// Invoked when a set up session is complete. This means that two
    /// or four devices are connected and ready to start the main session
    /// - parameter manager: The set up manager providing this information.
    func setupManagerDidComplete(_ manager: FourInOneSetupManager)
    
    /// Invoked when a set up manager rejects and invitation. The reason for this
    /// would typically be that the maximum number of devices is already connected.
    /// - parameter manager: The set up manager providing this information.
    func setupManagerDidRejectInvite(_ manager: FourInOneSetupManager)
    
    /// Invoked when a set up manager has lost the connection to a peer.
    /// The typical reason for this would be that one of the participants
    /// has decided to leave the the session.
    /// - parameter manager: The set up manager providing this information.
    /// - parameter peer: The peer that dropped out.
    /// - parameter mode: The mode the manager was in before the peer left.
    func setupManager(_ manager: FourInOneSetupManager, lostPeer peer:MCPeerID, inMode mode:GameMode)
    
    /// Invoked when a set up manager currently connecting two devices finds and
    /// connects to a third peer.
    /// - parameter manager: The set up manager providing this information.
    /// - parameter peer: The newly connected peer.
    func setUpManager(_ manager: FourInOneSetupManager, foundThirdPeer peer:MCPeerID)
    
    /// Invoked when a set up manager changes position. This could be a reason to update the user
    /// interface in order to inform users how the devices should be arranged.
    /// - parameter manager: The set up manager providing this information.
    /// - parameter position: The new position of this device.
    /// - parameter mode: The mode of the set up manager.
    func setUpManager(_ manager: FourInOneSetupManager, didChangePosition position:DevicePosition, withMode mode:GameMode)
    
    /// Invoked when the device acting as server changes during a set up session.
    /// Typically this is mostly interesting for debug purposes.
    /// - parameter manager: The set up manager providing this information.
    /// - parameter peer: The peer that is now server.
    func setupManager(_ manager: FourInOneSetupManager, didChangeServerToPeer peer:MCPeerID)
    
    /// Invoked when the devices connected to this sessions changes.
    /// Typically this is mostly interesting for debug purposes.
    /// - parameter manager: The set up manager providing this information.
    /// - parameter devices: An array containing the device's display names.
    func setUpManager(_ manager: FourInOneSetupManager, connectedDevicesDidChange devices: [String])
    
    func setupManagerDidStartGame(_ manager: FourInOneSetupManager)
    
}


enum FourInOneSetupEvent {
    
    case start
    case complete
    case server(String)
    case mode(GameMode)
    case position(DevicePosition)
    case holding(Bool)
    
}

// Used for sending messages to peers (easier to encode/decode)
struct FourInOneSetupMessage : Codable {
    
    enum EventType : Int, Codable {
        case start
        case complete
        case server
        case mode
        case position
        case holding
    }
    var type : EventType
    var message : String = ""
    var code : Int = 0
    
}

/**
 A FourInOneSetupManager handles the connecting phase of a session. It is designed to connect several devices with only a small amount of interaction from the users. The manager makes use of the MultiPeerConnectivity framework to manage the actual connection between deveices. When the set up phase ends one of the connected devices has been assigned the role to act as the server of the continued session.
 
 The main scenario behind the design consists of the following steps
 1. A menu screen is shown where participants select a team to join in a session
 2. A connecting screen is shown, based on which the participants can arrange their devices appropriately
 3. When the devices are arranged the participants perform some action that tells the setup manager that they are ready
 4. A new screen is shown that represents the actual activity
 
 The 4-in-1 framework assumes that devices are arranged like this
 ````
 ---------
 | 2 | 3 |
 ---------
 | 1 | 4 |
 ---------
 ````
 where the upper edge of each device is facing inwards. Thus in the figure above device 2 and 3 appear upside down. In order to form a large board the view in board 2 and 3 taking part in the board needs to be rotated 180 degrees.
 
 The work of the set up manager happens in step 2 and 3 listed above. The `FourInOneSetupManagerDelegate` protocol defines a number of methods that are invoked in order to define the user of this class of the progress of the set up process.
 
 The various steps  that are needed in step 2 and 3 are:
 ````
 // Create the manager
 let setupManager = FourInOneSetupManager()
 
 // Set the session type.
 // It should be unique for each simultaneous team.
 setupManager.sessionType = "\(FourInOneService)\(team)"
 
 // Set the delegate and start the session
 setupManager.delegate = self
 setupManager.startSetup()
 
 ...
 
 // The manager will inform its delegate about progress.
 // In particular it will tell the delegate when there are 2 or 4
 // devices connected.
 
 ...
 
 // Inform the manager that this device is ready to start the
 // main activity. The set up manager will let the delegate know when
 // all devices are ready.
 setupManager.readyAndWaitingForPeers()
 
 // When all devices are ready create a suitable session manager
 // and continue.
 var manager : FourInOneSessionManagerSubClass
 
 setupManager.initSessionManager(manager)
 
 // Tell the set up manager to end set up
 setupManager.finishSetup()
 
 // Use manager to handle the actual session.
 ````
 */
public class FourInOneSetupManager : NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    let kMaxAllowedPeers = 3
    
    // MARK: Properties
    /** The serviceType should be an identifier that uniquely identifies the service to be set up. */
    public var serviceType = "idac-4in1"
    
    /** The peer id representing this device in a session. It is created by the set up manager when a session is started */
    private(set) public var myPeerId: MCPeerID
    
    /** The peer id reperesenting the currently assigned server.*/
    private(set) public var server : MCPeerID
    
    /** Current game mode. */
    public var gameMode : GameMode
    
    /** Current device position */
    public var position : DevicePosition
    
    /** The manager's delegate */
    public var delegate : FourInOneSetupManagerDelegate?
    
    /** Whether this device acts as server or not. */
    public var isServer : Bool  {get {return myPeerId.displayName == server.displayName}}
    
    private var peerData : [PeerInfo] = []
    private var isHolding = false
    
    var session : MCSession
    private var serviceAdvertiser : MCNearbyServiceAdvertiser
    private var serviceBrowser : MCNearbyServiceBrowser
    
    // MARK: - Initializers
    
    /** Creates a new set up manager. */
    public override init() {
        
        myPeerId = MCPeerID(displayName: UIDevice.current.name)
        gameMode = .singleplayer
        position = .one
        
        // These are not really needed
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        self.session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        
        self.server = myPeerId
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
        
    }
    
    private func resetState() {
        
        //myPeerId = MCPeerID(displayName: UIDevice.current.name) // Is this needed?
        server = myPeerId
        gameMode = GameMode.singleplayer
        position = DevicePosition.one
        peerData = []
        isHolding = false
        
    }
    
    // MARK: - Starting and stopping
    
    /**
     Start searching for peers to connect to that have the same service type.
     */
    public func startSetup() {
        
        print("initiateSession")
        
        myPeerId = MCPeerID(displayName: makeDisplayname(Date()))
        
        resetState()
        
        transceive()
        
    }
    
    /**
     Stop searching for peers to connect to that have the same service type. Stopping setup
     keeps the underlying session and its connections, only the search for more connections is stopped.
     */
    public func stopSetup() {
        
        print("stopSetup")
        
        stopTransceiving()
        
    }
    
    /**
     Cancels and disconnects from the current set up session.
     */
    public func cancelSetup() {
        
        stopTransceiving()
        disconnectSession()
        
        OperationQueue.main.addOperation {
            
            self.delegate?.setupManagerDidCancel(self)
            
        }
        
    }
    
    private func restartSession () {
        
        print("restartSession")
        
        stopTransceiving()
        disconnectSession()
        
        //myPeerId = MCPeerID(displayName: UIDevice.current.name) // Is this needed?
        
        resetState()
        transceive()
        
    }
    
    /**
     Stop the search for peers to connect to. Call this when enough peers are connected.
     */
    public func finishSetup() {
        
        stopTransceiving()
        
    }
    
    private func stopTransceiving() {
        
        print("stopTransceiving")
        
        serviceAdvertiser.stopAdvertisingPeer()
        serviceAdvertiser.delegate = nil
        serviceBrowser.stopBrowsingForPeers()
        serviceBrowser.delegate = nil
        
    }
    
    
    
    // MARK: - Moving on
    
    /**
     Informs the set up manager that the device is in a mode where it is ready to end the set up phase and initiate the main 4-in-1 activity.
     */
    
    public func readyAndWaitingForPeers() {
        
        isHolding = true
        
        if isServer {
            
            //print("touchesBegan manager, server")
            startGameAndTellPeersIfStateValid()
            
        }
        else {
            
            //print("touchesBegan manager, client")
            send(event: .holding(true), to: server)
            
        }
        
    }
    
    /**
     
     Informs the set up manager that this device is no longer in a mode where it is ready to initiate the main 4-in-1 activity
     */
    public func cancelReadyAndWaiting() {
        
        isHolding = false
        
        if (isServer) {
            
            // Don't need to do anything
            
        }
        else {
            
            send(event: .holding(false), to: server)
            
        }
    }
    
    /*
     public func makeGameManager() -> FourInOneGameManager {
     
     if (isServer) {
     
     let manager = FourInOneGameServer()
     
     manager.peerId = myPeerId
     manager.session = session
     manager.mode = gameMode
     manager.position = position
     manager.clients = peerData
     
     return manager
     
     }
     else {
     
     let manager = FourInOneGameClient()
     
     manager.peerId = myPeerId
     manager.session = session
     manager.mode = gameMode
     manager.position = position
     manager.server = server
     
     return manager
     
     }
     }
     */
    /**
     Initializes a session manager with appropriate contents from the set up phase
     The session manager should be a concrete subclass of `FourInOneSessionManager`
     */
    public func initSessionManager(_ manager: FourInOneSessionManager) {
        
        manager.peerId = myPeerId
        manager.session = session
        manager.server = server
        manager.clients = peerData
        
        manager.mode = gameMode
        manager.position = position
        manager.isServer = isServer
        
    }
    
    // MARK: - Private methods
    
    // Re-start the service
    private func transceive() {
        
        // start all over
        resetState()
        
        print("transcieve \(Date())")
        
        session =  MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceAdvertiser.delegate = self
        
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        serviceBrowser.delegate = self
        
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
        
        //print("transcieve calling delegate")
        
        OperationQueue.main.addOperation {
            
            self.delegate?.setupManagerDidStartSession(self)
            
        }
        
    }
    
    private func disconnectSession() {
        
        print("disconnectSession")
        
        session.disconnect()
        session.delegate = nil
        peerData = []
        
    }
    
    private func changeServer(to newServer: MCPeerID) {
        
        print("Changing server to: \(newServer)")
        
        server = newServer
        
        OperationQueue.main.addOperation {
            
            self.delegate?.setupManager(self, didChangeServerToPeer: newServer)
            
        }
        
    }
    
    private func makeDisplayname(_ date:Date) -> String {
        
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "mmssSS"
        
        let randomId = Int(arc4random_uniform(1000))
        
        return "p-\(nameFormatter.string(from:date))-\(randomId)"
        
    }
    
    private func twoPlayerModeDetected(_ peer: MCPeerID) {
        
        gameMode = .twoplayer
        
        // print("twoPlayerMode \(isServer)")
        
        if (isServer && shouldContinueServing(peer)) { // Inform client about who is serving and its position
            
            send(event: .server(server.displayName), to: peer)
            send(event: .mode(.twoplayer), to:peer)
            send(event: .position(.two), to:peer)
            send(event: .complete, to:peer)
            
            if (peerData.count > 0) { // should be the case, could imagine multithread crash
                
                peerData[0].position = .two
                
            }
            
            OperationQueue.main.addOperation {
                
                self.delegate?.setUpManager(self, didChangePosition: .one, withMode: .twoplayer)
                self.delegate?.setupManagerDidComplete(self)
                
            }
            
        }
    }
    
    private func dropToTwoPlayerModeDetected() {
        
        gameMode = .twoplayer
        
        // print("twoPlayerMode \(isServer)")
        
        if (isServer) { // Drop to 2-player means that there should be no server change
            
            if (peerData.count > 0) { // should be the case, could imagine multithread crash
                
                let peer = peerData[0].peer
                
                peerData[0].position = .two
                
                send(event: .server(server.displayName), to: peer)
                send(event: .mode(.twoplayer), to:peer)
                send(event: .position(.two), to:peer)
                send(event: .complete, to:peer)
                
            }
            
            OperationQueue.main.addOperation {
                
                self.delegate?.setUpManager(self, didChangePosition: .one, withMode: .twoplayer)
                self.delegate?.setupManagerDidComplete(self)
                
            }
            
        }
    }
    
    private func threePlayersDetected(_ peer: MCPeerID) {
        
        // print("threePlayers \(isServer)")
        
        OperationQueue.main.addOperation {
            
            self.delegate?.setUpManager(self, foundThirdPeer: peer)
            
        }
        
    }
    
    private func fourPlayerModeDetected(_ peer: MCPeerID) {
        
        gameMode = .fourplayer
        
        if (isServer && shouldContinueServing(peer)) {
            
            let positions = [DevicePosition.two, .three, .four]
            var index = 0
            
            for peerInfo in peerData {
                
                if peerInfo.connected {
                    
                    let peer = peerInfo.peer
                    send(event: .server(server.displayName), to: peer)
                    send(event: .mode(.fourplayer), to: peer)
                    send(event: .position(positions[index]), to: peer)
                    send(event: .complete, to:peer)
                    
                    peerData[index].position = positions[index]
                    
                    if (index < positions.count-1) { // just to make sure that there are not too many connections
                        index = index + 1
                    }
                    
                }
            }
            
            OperationQueue.main.addOperation {
                
                self.delegate?.setUpManager(self, didChangePosition: .one, withMode: .fourplayer)
                self.delegate?.setupManagerDidComplete(self)
                
            }
        }
        
    }
    
    private func shouldContinueServing(_ peer: MCPeerID) -> Bool {
        
        if gameMode == .twoplayer {
            return myPeerId.displayName < peer.displayName
        }
        else { // fourplayer
            
            if myPeerId.displayName < peer.displayName { // check the rest
                
                for peerInfo in peerData {
                    
                    // maybe check that it's connected as well
                    if !(myPeerId.displayName < peerInfo.peer.displayName) {
                        
                        return false
                        
                    }
                }
                return true
            }
            
        }
        return false
    }
    
    private func playerLeftDetected(peer: MCPeerID) {
        
        print("playerLeftDetected")
        
        if server.displayName == peer.displayName { // server left
            
            print("server left session")
            server = myPeerId
            
            restartSession()
            
        }
        OperationQueue.main.addOperation {
            
            self.delegate?.setupManager(self, lostPeer: peer, inMode: self.gameMode)
            
        }
        // print("left telling delegate mode \(gameMode)")
        
    }
    
    private func startGameAndTellPeersIfStateValid() {
        
        if canIssueStartFromCurrentState() {
            
            startPeers()
            
            startGame()
        }
    }
    
    private func canIssueStartFromCurrentState() -> Bool {
        
        if !isServer || !isHolding {
            
            return false
        }
        // This is the server, and holding is on, check peers
        for peer in peerData {
            
            if !peer.holding {
                
                return false
                
            }
        }
        // Holding is on for all peers, check current number of peers
        switch gameMode {
        case .twoplayer:
            return session.connectedPeers.count == 1
        case .fourplayer:
            return session.connectedPeers.count == 3
        default:
            return false
        }
    }
    
    private func startGame() {
        
        // Why was this commented out?
        //self.stopTransceiving()
        
        OperationQueue.main.addOperation {
            
            self.delegate?.setupManagerDidStartGame(self)
            
        }
    }
    
    private func startPeers() {
        
        let start = FourInOneSetupEvent.start
        
        for peer in session.connectedPeers {
            
            send(event: start, to: peer)
            
        }
    }
    
    private func update(peer: PeerInfo) {
        
        var found = false
        let peerName = peer.peer.displayName
        let count = peerData.count
        
        for index in 0..<count {
            
            var thisPeer = peerData[index]
            
            if thisPeer.peer.displayName == peerName {
                
                found = true
                thisPeer.holding = peer.holding
                
            }
            peerData[index] = thisPeer
            
        }
        if !found {
            
            peerData.append(peer)
            
        }
    }
    
    private func update(peer: MCPeerID, connected: Bool) {
        
        var found = false
        
        let peerName = peer.displayName
        let count = peerData.count
        
        for index in 0..<count {
            
            if peerData[index].peer.displayName == peerName {
                
                found = true
                peerData[index].connected = connected
            }
            
        }
        if !found {
            
            peerData.append(PeerInfo(peer: peer, connected: connected, position: .one))
            
        }
    }
    
    private func remove(peer: MCPeerID) -> Bool {
        
        var found = false
        var index = 0
        var position = 0
        
        for peerInfo in peerData {
            
            if peerInfo.peer.displayName == peer.displayName {
                
                found = true
                position = index
                
            }
            index = index+1
            
        }
        if found {
            
            peerData.remove(at: position)
            return true
            
        }
        return false
    }
    
    // MARK: - Events
    
    private func send(event: FourInOneSetupEvent, to peer:MCPeerID) {
        
        send(message:createFrom(event: event), to:peer)
        
    }
    
    private func handle(event: FourInOneSetupEvent, fromPeer peerID: MCPeerID) {
        
        switch event {
            
        case .start:
            handleEvent(start:event, from:peerID)
        case .complete:
            handleEvent(complete:event, from:peerID)
        case .server(let name):
            handleEvent(server:name, from:peerID)
        case .mode(let gameMode):
            handleEvent(mode:gameMode, from:peerID)
        case .position(let devicePosition):
            handleEvent(position:devicePosition, from:peerID)
        case .holding(let touchDown):
            handleEvent(holding:touchDown, from:peerID)
            
        }
    }
    
    private func handleEvent(start event: FourInOneSetupEvent, from peerID: MCPeerID) {
        
        print("handle start event")
        startGame()
        
    }
    
    private func handleEvent(complete event: FourInOneSetupEvent, from peerId:MCPeerID ) {
        
        OperationQueue.main.addOperation {
            
            self.delegate?.setupManagerDidComplete(self)
            
        }
        
    }
    
    private func handleEvent(server: String, from peerId:MCPeerID ) {
        
        changeServer(to: peerId)
        
    }
    
    private func handleEvent(mode:GameMode, from peerId:MCPeerID)  {
        
        self.gameMode = mode
        
    }
    
    private func handleEvent(position: DevicePosition, from peerId:MCPeerID ) {
        
        self.position = position
        
        OperationQueue.main.addOperation {
            
            self.delegate?.setUpManager(self, didChangePosition: position, withMode: self.gameMode)
            
        }
        
    }
    
    private func handleEvent(holding: Bool, from peerId:MCPeerID ) {
        
        let senderName = peerId.displayName
        let count = peerData.count
        
        // update holding for this peer
        for index in 0..<count {
            
            if peerData[index].peer.displayName == senderName {
                
                peerData[index].holding = holding
                
            }
        }
        
        startGameAndTellPeersIfStateValid()
        
    }
    
    
    
    
    
    // MARK: - Low-level message handling
    
    private func send(message setupMessage: FourInOneSetupMessage, to peer:MCPeerID) {
        
        let encoder = JSONEncoder()
        
        // print("send: \(setupMessage)")
        
        if let messageData = try? encoder.encode(setupMessage) {
            
            do {
                
                try session.send(messageData, toPeers: [peer], with: .reliable)
            }
            catch {
                
                print("sending data to \(peer.displayName) failed")
            }
            
        }
    }
    
    private func createFrom(event:FourInOneSetupEvent) -> FourInOneSetupMessage {
        
        var message : FourInOneSetupMessage
        
        switch event {
            
        case .start:
            message = FourInOneSetupMessage(type: .start, message: "", code: 0)
            
        case .complete:
            message = FourInOneSetupMessage(type: .complete, message: "", code: 0)
            
        case .server(let name):
            message = FourInOneSetupMessage(type: .server, message: name, code: 0)
            
        case .mode(let mode):
            message = FourInOneSetupMessage(type: .mode, message: "", code: mode.rawValue)
            
        case .position(let position):
            message = FourInOneSetupMessage(type: .position, message: "", code: position.rawValue)
            
        case .holding(let value):
            let intValue = value ? 1 : 0
            message = FourInOneSetupMessage(type: .holding, message: "", code: intValue)
            
        }
        
        return message
        
    }
    
    private func createFrom(message: FourInOneSetupMessage) -> FourInOneSetupEvent {
        
        var event : FourInOneSetupEvent
        
        switch message.type {
            
        case .start:
            event = .start
            
        case .complete:
            event = .complete
            
        case .server:
            event = .server(message.message)
            
        case .mode:
            event = .mode(GameMode(rawValue:message.code)!)
            
        case .position:
            event = .position(DevicePosition(rawValue: message.code)!)
            
        case .holding:
            let boolValue = message.code == 1
            event = .holding(boolValue)
            
        }
        return event
    }
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
        print("didNotStartAdvertisingPeer: \(error)")
        
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                           didReceiveInvitationFromPeer peerID: MCPeerID,
                           withContext context: Data?,
                           invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        print("didReceiveInvitationFromPeer \(peerID)")
        
        let invitingPeer = PeerInfo(peer: peerID)
        
        update(peer: invitingPeer)
        
        let shouldAcceptInvitation = session.connectedPeers.count < kMaxAllowedPeers
        
        if !shouldAcceptInvitation {
            
            print(">> Too many peers!")
            OperationQueue.main.addOperation {
                
                self.delegate?.setupManagerDidRejectInvite(self)
                
            }
            
        }
        
        invitationHandler(shouldAcceptInvitation, session)
        
    }
    
    // MARK: - MCNearbyServiceBrowserDelegate
    
    
    public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        // print("foundPeer: \(peerID)")
        
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
    
    // MARK: - MCSessionDelegate
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        print("peer \(peerID) didChangeState: \(state)")
        
        // debug thing mostly
        OperationQueue.main.addOperation {

        self.delegate?.setUpManager(self, connectedDevicesDidChange: session.connectedPeers.map({$0.displayName}))
            
        }
        

        if (state == .notConnected) { // remove this peer
            
            let didRemovePeer = remove(peer: peerID)
            
            // This is to prevent the case where some peer that is not stored is reported as disconnected
            if (didRemovePeer) {
                
                if session.connectedPeers.count == 1 {
                    
                    // Keeping track of who was who etc is complicated, just start again
                    restartSession()
                    OperationQueue.main.addOperation {
                        
                        self.delegate?.setupManager(self, lostPeer: peerID, inMode: .twoplayer)
                        
                    }
                    
                }
                else {
                    
                    playerLeftDetected(peer:peerID)
                    
                }
            }
            
        }
        else { // update stored info about this peer
            
            update(peer: peerID, connected: state == .connected)
            // print("peers \(peerData)")
            
            if (state == .connected) { // number of peers should have increased
                
                let peers = session.connectedPeers
                
                switch peers.count {
                case 1:
                    
                    // print("case 1")
                    twoPlayerModeDetected(peerID)
                    
                case 2:
                    
                    // print("case 2")
                    threePlayersDetected(peerID)
                    
                case 3:
                    
                    // print("case 3")
                    fourPlayerModeDetected(peerID)
                    
                default:
                    
                    print("case other")
                    
                }
            }
        }
        
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        do {
            
            let receivedMessage = try JSONDecoder().decode(FourInOneSetupMessage.self, from: data)
            
            // print("receive: \(receivedMessage)")
            
            handle(event: createFrom(message: receivedMessage), fromPeer: peerID)
            
        }
        catch {
            
            print("Setup manager error decoding \(data)")
        }
        
    }
    
    // Not used
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
}

extension MCSessionState {
    
    func stringValue() -> String {
        switch(self) {
        case .notConnected: return "notConnected"
        case .connecting: return "connecting"
        case .connected: return "connected"
        }
    }
    
}



