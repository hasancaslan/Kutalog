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
    var allCourses: [Course]? = [Course]()
    var filteredCourses: [Course]? = [Course]()
    let searchController = UISearchController(searchResultsController: nil)
    private let debouncer = Debouncer(seconds: 0.3)
    private lazy var dataSource: ClassSearchDataSource = {
        let source = ClassSearchDataSource()
        source.fetchedResultsControllerDelegate = self
        source.delegate = self
        return source
    }()
    // MARK: - View
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 1
    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.text = "No Results"
        label.font = UIFont.boldSystemFont(ofSize: 34.0)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add spinner to superview
        if spinner.superview == nil, allCourses?.isEmpty ?? true, let superView = classListCollectionView.superview {
            superView.addSubview(spinner)
            superView.bringSubviewToFront(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        }
        // Add "No Results" label to superview
        if let superView = classListCollectionView.superview {
            superView.addSubview(noResultsLabel)
            superView.bringSubviewToFront(noResultsLabel)
            noResultsLabel.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            noResultsLabel.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
            noResultsLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        dataSource.loadCourseList()
    }
    
    // MARK: - Helpers
    func setupSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Courses"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Code", "Name", "Description"]
        searchController.searchBar.delegate = self
    }
    
    func filterContentForSearchText(_ searchText: String?, scope: String = "All") {
        guard let query = searchText else {
            return
        }
        debouncer.debounce {
            self.filteredCourses = self.allCourses?.filter({( course: Course) -> Bool in
                var doesCategoryMatch = true
                switch scope {
                case "All":
                    doesCategoryMatch = course.title?.lowercased().contains(query.lowercased()) ?? false || course.moduleCode?.lowercased().contains(query.lowercased()) ?? false
                    break
                case "Code":
                    doesCategoryMatch = course.moduleCode?.lowercased().contains(query.lowercased()) ?? false
                    break
                case "Name":
                    doesCategoryMatch = course.title?.lowercased().contains(query.lowercased()) ?? false
                    break
                case "Description":
                    doesCategoryMatch = course.moduleDescription?.lowercased().contains(query.lowercased()) ?? false
                    break
                default:
                    break
                }
                if self.searchBarIsEmpty() {
                    return true
                } else {
                    return doesCategoryMatch
                }
            })
            DispatchQueue.main.async {
                self.classListCollectionView.reloadData()
                if self.filteredCourses?.isEmpty ?? true {
                    self.noResultsLabel.isHidden = false
                } else {
                    self.noResultsLabel.isHidden = true
                }
            }
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! ClassCollectionViewCell
        let indexPath = classListCollectionView.indexPath(for: cell)
        if let indexPath = indexPath {
            let course: Course?
            if isFiltering() {
                course = filteredCourses?[indexPath.row]
            } else {
                course = allCourses?[indexPath.row]
            }
            if let vc = segue.destination as? SearchedClassDetailViewController {
                vc.course = course
                //vc.dataSource = dataSource
            }
        }
    }
}

// MARK: - UICollectionView DataSource and Delegate
extension ClassSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCourses?.count ?? 0
        }
        return allCourses?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCell", for: indexPath) as? ClassCollectionViewCell else { return UICollectionViewCell() }
        let course: Course?
        if isFiltering() {
            course = filteredCourses?[indexPath.row]
        } else {
            course = allCourses?[indexPath.row]
        }
        cell.configure(with: course)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let course: Course?
        //        if isFiltering() {
        //            course = filteredCourses?[indexPath.row]
        //        } else {
        //            course = allCourses?[indexPath.row]
        //        }
        //        if let moduleCode = course?.moduleCode{
        //            dataSource.loadCourseDetail(moduleCode: moduleCode, course: C)
        //        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ClassSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 2 * widthPerItem / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - NSFetchedResultsController Delegate
extension ClassSearchViewController: NSFetchedResultsControllerDelegate {
    /**
     Reloads the table view when the fetched result controller's content changes.
     */
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.dataSource.loadCourseList()
    }
}

// MARK: - UISearchBar Delegate
extension ClassSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension ClassSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text, scope: scope)
    }
}

// MARK: - ClassSearchDataSource Delegate
extension ClassSearchViewController: ClassSearchDataSourceDelegate {
    func courseListLoaded(courseList: [Course]?) {
        self.allCourses = courseList
        if allCourses?.isEmpty ?? true {
            spinner.startAnimating()
            dataSource.fetchCourseList { error in
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
        DispatchQueue.main.async {
            self.classListCollectionView.reloadData()
        }
    }
}
