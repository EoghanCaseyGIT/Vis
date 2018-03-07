//
//  SwitchTableViewCell.swift
//  imagepicker
//
//  Created by Eoghan Casey on 19/12/2017.
//  Copyright © 2017 Eoghan Casey. All rights reserved.
//


import UIKit

let SWITCH_TABLE_CELL_REUSE_IDENTIFIER = "switchCell"

protocol SwitchTableViewCellDelegate {
    func switchCellSwitched(_ cell: SwitchTableViewCell, status: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    var delegate:SwitchTableViewCellDelegate?
    @IBOutlet weak var switchLabel:UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if (delegate != nil) {
            delegate!.switchCellSwitched(self, status: sender.isOn)
        }
    }

}
