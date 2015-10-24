//
//  PlacesTableViewCell.swift
//  memorable-places
//
//  Created by Jason Shultz on 10/22/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
        
    @IBOutlet weak var locationNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
