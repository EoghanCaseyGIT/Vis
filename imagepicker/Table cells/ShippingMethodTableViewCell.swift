//
//  ShippingMethodTableViewCell.swift
//  imagepicker
//
//  Created by Eoghan Casey on 19/12/2017.
//  Copyright © 2017 Eoghan Casey. All rights reserved.
//


import UIKit

class ShippingMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var methodNameLabel:UILabel?
    @IBOutlet weak var costLabel:UILabel?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
