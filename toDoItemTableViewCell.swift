//
//  toDoItemTableViewCell.swift
//  PostMessage
//
//  Created by System Administrator on 12/26/16.
//  Copyright © 2016 yangzhiqiong. All rights reserved.
//

import UIKit

class toDoItemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var priorityImageView: UIImageView!
    
    
    @IBOutlet weak var taskDate: UITextField!
    
    
    @IBOutlet weak var TaskTitle: UITextView!
    
    
    @IBOutlet weak var taskDuration: UITextField!
    
    
    @IBOutlet weak var TaskState: UITextField!
    
    
    

    
}
