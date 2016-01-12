//
//  ViewController.swift
//  MoblieMakersChallenge
//
//  Created by smorris on 12/14/15.
//  Copyright © 2015 LNG. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    // Making variables
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    var name: String = "Nugget McGee"
    var choice: String = "I'm a nuggest"
    let serviceType = "LCOC-Chat"
    var messageArray = [Message]()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textHere: UILabel!
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()
        
        
        
        loadSampleMessages()
        
       
        
    }
    @IBAction func closeKeyboardButtonTapped(sender: UIButton)
    {
        messageTextField.resignFirstResponder()
    }
    
    // Send message action
    @IBAction func sendButtonTapped(sender: UIButton)
    {
        // Bundle up the text in the message field, and send it off to all
        // connected peers
        
        
        let msg = self.messageTextField.text!.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
//        let data = NSData(bytes: &msg, length: sizeof(Int))
        
        
        try! self.session.sendData(msg!, toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable)
        
        self.updateChat(self.messageTextField.text!, fromPeer: self.peerID)
        
        self.messageTextField.text = String(choice)
        
        
        print(String(msg))
    }
    
    // Tells the table view how many cells to make
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messageArray.count
        
    }
    
    // Displays the cell with the message on it
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        cell.textLabel?.text = messageArray[indexPath.row].messageText
        return cell
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let message = messageArray[sourceIndexPath.row]
        messageArray.removeAtIndex(sourceIndexPath.row)
        messageArray.insert(message, atIndex: destinationIndexPath.row)
    }
    
    // Loads sample messages for testing purposes
    func loadSampleMessages()
    {
        let sample1 = Message(style: UITableViewCellStyle.Default, reuseIdentifier: "test", messageText: "lol")
        let sample2 = Message(style: UITableViewCellStyle.Default, reuseIdentifier: "Sample Text 2", messageText: "I too am a sample text")
        let sample3 = Message(style: UITableViewCellStyle.Default, reuseIdentifier: "Sample Text 3", messageText: "Way to be original, loser")
        messageArray.append(sample1)
        messageArray.append(sample2)
        messageArray.append(sample3)
    }
    
    //various mulitpeer funcitons 
    @IBAction func showBrowser(sender: UIButton) {
        // Show the browser view controller
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is dismissed (ie the Done
            // button was tapped)
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is cancelled
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func updateChat(text : String, fromPeer peerID: MCPeerID) {
        // Appends some text to the chat view
        
        // If this peer ID is the local device's peer ID, then show the name
        // as "Me"
        
        switch peerID {
        case self.peerID:
            name = "Me"
        default:
            name = peerID.displayName
        }
        
    }
    
    func session(session: MCSession, didReceiveData data: NSData,
        fromPeer peerID: MCPeerID)  {
            // Called when a peer sends an NSData to us
            
            // This needs to run on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                
                let msg = NSString(data: data, encoding: NSUTF8StringEncoding)
                print(String(msg))
                self.textHere.text = String(msg)
                
                self.updateChat(String(msg), fromPeer: peerID)
            }
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID, withProgress progress: NSProgress)  {
            
            updateChat(String(msg), fromPeer: self.peerID)
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

