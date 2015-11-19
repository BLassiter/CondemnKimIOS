//
//  StoreItem.swift
//  Condemn Kim
//
//  Created by Brandon lassiter on 11/19/15.
//  Copyright © 2015 Brandon Lassiter. All rights reserved.
//

import UIKit

class StoreItem: NSObject {
    
    var backgroundImage : UIImage?;
    var cost : Int = 0;
    var filename : String = "";
    
    init(image: UIImage, cost: Int, _filename: String) {
        self.backgroundImage = image;
        self.cost = cost;
        self.filename = _filename;
    }

}
