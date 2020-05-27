//
//  TubeLineTableViewCell.swift
//  TestabilityAppStoryboard
//
//  Created by William Do on 07/05/2020.
//  Copyright © 2020 William Do. All rights reserved.
//

import UIKit

class TubeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var lineNameLabel: UILabel!
    
    @IBOutlet weak var lineStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
