//
//  SettingCell.swift
//  KUtalog
//
//  Created by HASAN CAN on 24.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    @IBOutlet weak var settingsCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        settingsCellLabel.text = nil
    }
    
}
