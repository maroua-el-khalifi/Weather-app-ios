//
//  HourlyTableViewCell.swift
//  projet_meteo_ios_marelk
//
//  Created by user on 07/02/2023.
//  Copyright © 2023 user. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "HourlyTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    
}
