//
//  SettingsViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var shareApp: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    private var settingsCellData: [String] {
        let setting = ["Privacy Policy and EULA", "About Us"]
        return setting
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.shareApp.layer.cornerRadius = 15.0
        self.logOutButton.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [URL(string: "https://kutalog.flycricket.io")!],
                                          applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
       let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LandingNavigationController") as! UINavigationController
                           let appDelegate = UIApplication.shared.delegate as! AppDelegate
                           appDelegate.window?.rootViewController = controller
        } catch let signOutError as NSError {
          DispatchQueue.main.async {
              let alert = UIAlertController(title: "There was an error when log out.", message: signOutError.localizedDescription, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
              self.present(alert, animated: true)
          }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settingsCellData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.settingsCellLabel.text = setting
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let url = URL(string: "https://kutalog.flycricket.io/privacy.html"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else if indexPath.row == 1 {
            if let url = URL(string: "https://kutalog.flycricket.io"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
