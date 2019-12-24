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
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
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
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    @IBOutlet weak var classListCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        moduleDataSource.delegate = self
        moduleDataSource.loadClassList()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        //activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.startAnimating()
        classListCollectionView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: classListCollectionView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: classListCollectionView.centerYAnchor).isActive = true
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
