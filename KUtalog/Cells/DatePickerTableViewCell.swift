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
    @IBOutlet weak var deadlineLabel: UILabel!
    
    var delegate: DatePickerTableViewCellDelegate?
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy EEEE HH:mm"
        return formatter
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateLabel.text = dateFormatter.string(from: self.datePicker.date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        self.dateLabel.text = dateFormatter.string(from: self.datePicker.date)
        self.delegate?.getSelectedDate(date: datePicker.date)
    }
}
