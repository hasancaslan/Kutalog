//
//  LandscapeTimetableCollectionViewCell.swift
//  KUtalog
//
//  Created by Ceren on 15.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit


class LandscapeTimetableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var classCodeLabel: UILabel!
    
    func addClass(course: Course?, addLabel: Bool, color: UIColor){
        if let course = course {
            if addLabel {
                self.classCodeLabel.text = course.moduleCode
                self.classCodeLabel.transform = CGAffineTransform(rotationAngle: .pi/2*3)
            } else {
                self.classCodeLabel.text = ""
            }
            self.contentView.backgroundColor = .red
        } else {
            self.classCodeLabel.text = ""
            self.contentView.backgroundColor = color
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.classCodeLabel.text = ""
        self.backgroundColor = .gray
    }
}
