//
//  PeopleCell.swift
//  Final Project Take 2
//
//  Created by Nick on 4/24/17.
//  Copyright © 2017 Nick Ryan. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {
    
    @IBOutlet weak var cellDistance: UILabel!
    @IBOutlet weak var cellAddress: UILabel!
    @IBOutlet weak var cellName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurePeopleCell(name: String, latitude: Double, longitude: Double, address: String, distance: Double, placeChosen: Bool) {
        print(name)
        if placeChosen == false {
            cellDistance.isHidden = true
        } else {
            cellDistance.isHidden = false
        }
        cellDistance.text = "\(distance) miles from chosen location"
        cellAddress.text = address
        cellName.text = name
    }
}
