//
//  TaskTableViewCell.swift
//  KUtalog
//
//  Created by Ceren on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

protocol TaskTableViewCellDelegate {
    func editTapped(task: Task?)
    func deleteTapped(task: Task?)
}

class TaskTableViewCell: UITableViewCell {
    var delegate: TaskTableViewCellDelegate?
    var task: Task?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var descriptionLabelHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        courseCodeLabel.text = ""
        timeLabel.text = ""
        descriptionLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        courseCodeLabel.text = ""
        timeLabel.text = ""
        descriptionLabel.text = ""
        descriptionLabelHeightAnchor.constant = 0
        delegate = nil
        task = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func configure(task: Task?, background: UIColor) {
        self.task = task
        self.contentView.backgroundColor = background
        self.topView.backgroundColor = background
        if let title = task?.title {
            titleLabel.text = title
        }
        if let moduleCode = task?.moduleCode {
            courseCodeLabel.text = moduleCode
        }
        if let date = task?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE HH:mm"
            timeLabel.text = dateFormatter.string(from: date)
        }
        if let taskDescription = task?.taskDescription {
            descriptionLabel.text = taskDescription
            if taskDescription != "" {
                descriptionLabelHeightAnchor.constant = taskDescription.height(withConstrainedWidth: self.contentView.frame.width - 40, font: .systemFont(ofSize: 12))
            }
        }
    }
    
    @IBAction func deleteTap(_ sender: Any) {
        self.delegate?.deleteTapped(task: task)
    }
    @IBAction func editTap(_ sender: Any) {
        self.delegate?.editTapped(task: task)
    }
}
