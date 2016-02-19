//
//  ViewController.swift
//  MoblieMakersChallenge
//
//  Created by smorris on 12/14/15.
//  Copyright © 2015 LNG. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    // Making variables
    var browser : MCBrowserViewController!
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
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textHere: UILabel!
    @IBOutlet weak var backgroundTextImageInert: UIImageView!
    @IBOutlet weak var backgroundTextImageActive: UIImageView!
    @IBOutlet var tapGesterTester: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.view.addGestureRecognizer(tapGesterTester)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        self.messageTextField.delegate = self
        textFieldDidBeginEditing(messageTextField)
        backgroundTextImageActive.alpha = 0

        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
        
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.activeText = textField
        animateViewMoving(true, moveValue: 235)
        backgroundTextImageActive.alpha = 1

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 235)
        backgroundTextImageActive.alpha = 0

        
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 4
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
    }
    
    // Get rid of the keyboard.
    @IBAction func closeKeyboardButtonTapped(sender: UIButton)
    {
        messageTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == messageTextField{
            sendMessage()
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    // Send message action
     func sendMessage()
    {
        // Bundle up the text in the message field, and send it off to all
        // connected peers
        
         print(String(self.messageTextField.text))
        messageArray.append(String(self.messageTextField.text!))
        var msg = self.messageTextField.text?.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        _ = NSData(bytes: &msg, length: sizeof(Int))
        
        
        
       //var data = NSData(bytes: &msg, length: sizeof(Int))
//        let data = NSData(bytes: &msg, length: sizeof(Int))
        
        do {
            try self.session.sendData(msg!, toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable)
            }
        catch
        {
            print("\(error)")
        }
        self.updateChat(self.messageTextField.text!, fromPeer: self.peerID)
        self.messageTextField.text = String(choice)
        
        tableView.reloadData()
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
        cell.textLabel?.text = messageArray[indexPath.row]
        return cell
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
    
    // Called when the browser view controller is cancelled
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController)  {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Appends some text to the chat view
    func updateChat(text : String, fromPeer peerID: MCPeerID) {
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
                print(String(msg!))
                self.messageHolder = String(msg!)
                self.updateChat(String(msg), fromPeer: peerID)
              
            }
            _ = messageHolder
            
            for thing in messageArray
            {
                print(thing)
                print(messageArray.count)
            }
            messageArray.append(messageHolder)
            tableView.reloadData()
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
    @IBAction func onScreenTappped(sender: UITapGestureRecognizer)
    {
        messageTextField.resignFirstResponder()
    }

}

