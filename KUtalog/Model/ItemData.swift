//
//  ItemData.swift
//  KUtalog
//
//  Created by HASAN CAN on 18.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

struct ItemData: Decodable {
    let data: [Item]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Item].self, forKey: CodingKeys.data)
    }
}
