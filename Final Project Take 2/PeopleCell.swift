//
//  PeopleCell.swift
//  Final Project Take 2
//
//  Created by Nick on 4/24/17.
//  Copyright © 2017 Nick Ryan. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {
    
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var cellStatus: UILabel!
    @IBOutlet weak var cellLocation: UILabel!
    @IBOutlet weak var cellName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurePeopleCell(icon: String, name: String, latitude: Double, longitude: Double, status: String) {
        cellLocation.text = String(latitude) + ", " + String(longitude)
        cellStatus.text = status
        cellName.text = name
        cellIcon.image = UIImage(named: icon)
    }

}
