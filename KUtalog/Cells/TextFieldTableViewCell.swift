//
//  TextFieldTableViewCell.swift
//  KUtalog
//
//  Created by Ceren on 13.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate {
    func getTitle(title: String?)
    func getDescription(description: String?)
}

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    var delegate: TextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField?.text =  ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didChangeValue(_ sender: Any) {
        if textField.placeholder == "Title" {
            self.delegate?.getTitle(title: textField.text)
        } else if textField.placeholder == "Description" {
            self.delegate?.getDescription(description: textField.text)
        }
    }
    

}
