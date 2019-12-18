//
//  PickerTableViewCell.swift
//  KUtalog
//
//  Created by Ceren on 13.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

extension PickerTableViewCell: EditTaskViewControllerDelegate {
    func preselectedCourse(row: Int) {
        coursePickerView.selectRow(row, inComponent: 0, animated: false)
    }
}

protocol PickerTableViewCellDelegate {
    func pickedCourse(course: String, row: Int)
}

class PickerTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var coursePickerView: UIPickerView!
    @IBOutlet weak var coursePickerLabel: UILabel!
    var pickerData: [String] = [String]()
    var delegate: PickerTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.coursePickerView.delegate = self
        self.coursePickerView.dataSource = self
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pickerData = [String]()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.pickedCourse(course: pickerData[row], row: row)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
