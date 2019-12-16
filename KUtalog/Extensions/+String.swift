//
//  +String.swift
//  KUtalog
//
//  Created by HASAN CAN on 16.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
