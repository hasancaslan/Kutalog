//
//  DatePickerTableViewCell.swift
//  KUtalog
//
//  Created by Ceren on 13.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

protocol DatePickerTableViewCellDelegate {
    func getSelectedDate(date: Date)
}

class DatePickerTableViewCell: UITableViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    var delegate: DatePickerTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        self.delegate?.getSelectedDate(date: datePicker.date)
    }
}
