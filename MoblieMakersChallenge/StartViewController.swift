//
//  StartViewController.swift
//  MoblieMakersChallenge
//
//  Created by Kristian Carter on 2/19/16.
//  Copyright © 2016 LNG. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class StartViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate{

    @IBOutlet weak var findFriendsOutlet: UIButton!
    var finder : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var tester : Bool = false
    var peerID: MCPeerID!
    var messageHolder : String = ""
    var name: String = "Nugget McGee"
    var choice: String = "I'm a nuggest"
    let serviceType = "LCOC-Chat"
    var messageArray = ["Sample Text", "Same", "I'm so hungry"]
    var activeText = UITextField()
    @IBOutlet weak var talkButton: UIButton!
    @IBOutlet weak var findAFriendButton: UIButton!
    @IBOutlet weak var stuffTextField: UITextView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.talkButton.alpha = 0
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self

        self.finder = MCBrowserViewController(serviceType:serviceType, session:self.session)
        
        self.finder.delegate = self;
        
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType, discoveryInfo:nil, session:self.session)
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    // Send message action
    func sendMessage()
    {
    }
    
   
    //various mulitpeer funcitons
    @IBAction func showBrowser(sender: UIButton) {
        // Show the browser view controller
        self.presentViewController(self.finder, animated: true, completion: nil)
    
    }
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is dismissed (ie the Done
            // button was tapped)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            self.talkButton.alpha = 100
            self.findAFriendButton.alpha = 0
            stuffTextField.text = "Good now just go and talk by pressing that button ->"
            
    }
    
    // Called when the browser view controller is cancelled
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController)  {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Appends some text to the chat view
    func updateChat(text : String, fromPeer peerID: MCPeerID) {
        // If this peer ID is the local device's peer ID, then show the name
        // as "Me"
  
        
    }
    
    func session(session: MCSession, didReceiveData data: NSData,
        fromPeer peerID: MCPeerID)  {
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID, withProgress progress: NSProgress)  {
            
    }
    
    func session(session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        atURL localURL: NSURL, withError error: NSError?)  {
            // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream,
        withName streamName: String, fromPeer peerID: MCPeerID)  {
            // Called when a peer establishes a stream with us
    }
    
    func session(session: MCSession, peer peerID: MCPeerID,
        didChangeState state: MCSessionState)  {
            // Called when a connected peer changes state (for example, goes offline)
            
    }
    
    
}

