//
//  ExpandableTableViewCell.swift
//  KUtalog
//
//  Created by Ceren on 12.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import ExpandableCell

class ExpandableTableViewCell: ExpandableCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func isSelectable() -> Bool {
        return true
    }
    
    override func isInitiallyExpanded() -> Bool {
        return false
    }

}
