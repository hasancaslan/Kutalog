//
//  TaskTableViewCell.swift
//  KUtalog
//
//  Created by Ceren on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var editButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        courseCodeLabel.text = ""
        timeLabel.text = ""
        descriptionTextField.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(task: Task?) {
        if let title = task?.title {
            titleLabel.text = title
        }
        if let moduleCode = task?.moduleCode {
            courseCodeLabel.text = moduleCode
        }
        if let date = task?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            timeLabel.text = dateFormatter.string(from: date)
        }
        if let taskDescription = task?.taskDescription {
            descriptionTextField.text = taskDescription
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        courseCodeLabel.text = ""
        timeLabel.text = ""
        descriptionTextField.text = ""
    }
    
}
