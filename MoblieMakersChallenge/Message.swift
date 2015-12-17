//
//  Message.swift
//  MoblieMakersChallenge
//
//  Created by smorris on 12/16/15.
//  Copyright © 2015 LNG. All rights reserved.
//

import UIKit

class Message: UITableViewCell {

    var messageText: String = ""
    var timestamp: String = ""
    var sender: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, messageText: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.text = messageText
    }

    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        
    }
    

}
