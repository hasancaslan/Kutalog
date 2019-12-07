//
//  ClassSearchViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

extension ClassSearchViewController: ClassSearchDataSourceDelegate {
    func moduleListLoaded(moduleList: [Module]) {
        self.moduleArray = moduleList
        self.classListCollectionView.reloadData()
    }
}

extension ClassSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moduleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCell", for: indexPath) as! ClassCollectionViewCell
        let index = indexPath.row
        let module = moduleArray[index]
        cell.captionLabel.text = module.moduleCode
        cell.titleLabel.text = module.title
        cell.infoTextView.text = module.description
        return cell
    }
    
    
}

class ClassSearchViewController: UIViewController {

    let moduleDataSource = ClassSearchDataSource()
    var moduleArray: [Module] = []
    @IBOutlet weak var classListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleDataSource.delegate = self
        moduleDataSource.loadClassList()
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let cell = sender as! ClassCollectionViewCell
//        let indexPath = classListCollectionView.indexPath(for: cell)
//
//        if let indexPath = indexPath {
//            let index = indexPath.row
//            let module = moduleArray[index]
//        }
//    }
    

}
