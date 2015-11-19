//
//  StoreCell.swift
//  Condemn Kim
//
//  Created by Brandon lassiter on 11/19/15.
//  Copyright © 2015 Brandon Lassiter. All rights reserved.
//

import UIKit

class StoreCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    var cost : Int = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var buyButton: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
