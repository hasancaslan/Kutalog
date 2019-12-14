//
//  PickerTableViewCell.swift
//  KUtalog
//
//  Created by Ceren on 13.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

protocol PickerTableViewCellDelegate {
    func pickedCourse(course: String)
}

class PickerTableViewCell: UITableViewCell, UIPickerViewDelegate {

    @IBOutlet weak var coursePickerView: UIPickerView!
    @IBOutlet weak var coursePickerLabel: UILabel!
    var pickerData: [String] = [String]()
    var delegate: PickerTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.coursePickerView.delegate = self
        self.coursePickerView.dataSource = self as? UIPickerViewDataSource
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func numberOfRows(inComponent: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.pickedCourse(course: pickerData[row])
    }
    
}
