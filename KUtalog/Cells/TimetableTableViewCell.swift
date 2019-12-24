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
    
    func configure(course: Course?, background: UIColor) {
        self.contentView.backgroundColor = background
        self.courseCodeLabel.text = course?.moduleCode
        self.coursePlaceLabel.text = course?.semesterData?.semesterData.first??.timetable?.first??.venue
        if let startTime = course?.semesterData?.semesterData.first??.timetable?.first??.startTime,
            let endTime = course?.semesterData?.semesterData.first??.timetable?.first??.endTime {
            let index = startTime.index(startTime.startIndex, offsetBy: 2)
            let time = startTime[..<index] + "." + startTime[index..<startTime.endIndex] + " " + endTime[..<index] + "." + endTime[index..<endTime.endIndex]
            self.startTimeLabel.text = String(time)
        }
    }
}
