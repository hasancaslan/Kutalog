//
//  TimetableTableViewCell.swift
//  KUtalog
//
//  Created by Ceren on 15.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

class TimetableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var coursePlaceLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.courseCodeLabel.text = ""
        self.coursePlaceLabel.text = ""
        self.startTimeLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.courseCodeLabel.text = ""
        self.coursePlaceLabel.text = ""
        self.startTimeLabel.text = ""
    }
    
    func configure(course: Course?) {
        self.courseCodeLabel.text = course?.moduleCode
        self.coursePlaceLabel.text = course?.semesterData?.semesterData.first??.timetable?.first??.venue
        self.startTimeLabel.text = course?.semesterData?.semesterData.first??.timetable?.first??.startTime
    }
    
}
