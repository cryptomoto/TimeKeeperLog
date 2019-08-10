//
//  WorkTableViewCell.swift
//  Keeper
//
//  Created by admin on 4/23/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit

class WorkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var statsLabel: UILabel!
    
    var checked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}
