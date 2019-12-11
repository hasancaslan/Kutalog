//
//  ClassCollectionViewCell.swift
//  KUtalog
//
//  Created by Ceren on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

class ClassCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            infoTextView.layer.borderWidth = isSelected ? 4 : 0
            infoTextView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func configure(with course: Course) {
        captionLabel.text = course.moduleCode
        titleLabel.text = course.title
        infoTextView.text = course.moduleDescription
       }
}
