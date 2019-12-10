//
//  ClassSearchViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import CoreData

class ClassSearchViewController: UIViewController {
    @IBOutlet weak var classListCollectionView: UICollectionView!
    
    private lazy var dataSource: ClassSearchDataSource = {
        let source = ClassSearchDataSource()
        source.fetchedResultsControllerDelegate = self
        return source
    }()
    
    // MARK: - View
    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if spinner.superview == nil, let superView = classListCollectionView.superview {
            superView.addSubview(spinner)
            superView.bringSubviewToFront(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        dataSource.loadClassList { error in
            DispatchQueue.main.async {
                
                // Update the spinner and refresh button states.
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.spinner.stopAnimating()
                
                // Show an alert if there was an error.
                guard let error = error else { return }
                let alert = UIAlertController(title: "Fetch classes error!",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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

// MARK: - UI Collection View Data Source and Delegate
extension ClassSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCell", for: indexPath) as! ClassCollectionViewCell
        guard let course = dataSource.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }
        cell.configure(with: course)
        return cell
    }
}

// MARK: - NS Fetched Results Controller Delegate
extension ClassSearchViewController: NSFetchedResultsControllerDelegate {
    /**
     Reloads the table view when the fetched result controller's content changes.
     */
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.classListCollectionView.reloadData()
    }
}
