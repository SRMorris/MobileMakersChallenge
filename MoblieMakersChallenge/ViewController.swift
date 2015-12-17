//
//  ViewController.swift
//  MoblieMakersChallenge
//
//  Created by smorris on 12/14/15.
//  Copyright © 2015 LNG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Making variables
    var messageArray = [Message]()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        loadSampleMessages()
    }
    
    // Send message action
    @IBAction func sendButtonTapped(sender: UIButton)
    {
        let newSentMessage: Message = Message(style: UITableViewCellStyle.Default, reuseIdentifier: "Test", messageText: messageTextField.text!)
        
        if(newSentMessage.textLabel != "")
        {
            messageArray.append(newSentMessage)
        }
        
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
}

