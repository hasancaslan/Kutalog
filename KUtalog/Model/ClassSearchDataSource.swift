//
//  ClassSearchDataSource.swift
//  KUtalog
//
//  Created by Ceren on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import Foundation

protocol ClassSearchDataSourceDelegate {
    func moduleListLoaded(moduleList: [Module])
}

class ClassSearchDataSource {
    var delegate: ClassSearchDataSourceDelegate?
    let baseUrl = "https://api.nusmods.com/v2/"

    func loadClassList() {
        let session = URLSession.shared

        if let url = URL(string: "\(baseUrl)2018-2019/moduleInfo.json") {

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let dataTask = session.dataTask(with: request) {data, _, _ in
                let decoder = JSONDecoder()
                let moduleList = try! decoder.decode([Module].self, from: data!)
                DispatchQueue.main.async {
                    self.delegate?.moduleListLoaded(moduleList: moduleList)
                }
            }
            dataTask.resume()
        }
    }
}
