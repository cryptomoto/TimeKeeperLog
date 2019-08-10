//
//  ClientCell.swift
//  Keeper
//
//  Created by admin on 5/15/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit

class ClientCell: UITableViewCell {

    @IBOutlet weak var clientName: UILabel!
    
    
    @IBOutlet weak var clientEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
