//
//  LandingViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class LandingViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleLabelLayoutConstraintToCenter: NSLayoutConstraint!
    @IBOutlet weak var logoLayoutConstraintToCenter: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerButton.layer.cornerRadius = 55/2
        self.loginButton.layer.cornerRadius = 55/2
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.navigationBar.isHidden = true
        
        // Save user information to UserDefaults for auto-login
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let email = UserDefaults.standard.string(forKey: "email"),
            let password = UserDefaults.standard.string(forKey: "password") else {
                DispatchQueue.main.async {
                    self.animateView()
                }
                return
        }
        
        // MARK:- Auto Log In
        Auth.auth().signIn(withEmail: email, password: password) {[unowned self] (user, err) in
            if err == nil {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                appDelegate.window?.rootViewController = controller
                return
            } else {
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "password")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "There was an error when logging in.", message: err?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        self.animateView()
                    }))
                    self.present(alert, animated: true)
                }
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    //    MARK:- Animations
    func animateView() {
        self.titleLabelLayoutConstraintToCenter.priority = UILayoutPriority(rawValue: 999)
        self.logoLayoutConstraintToCenter.priority = UILayoutPriority(rawValue: 1)
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [.calculationModeCubic], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0/1.5, animations: {
                self.view.layoutIfNeeded()
                self.titleLabel.alpha = 1.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1.0/1.5, relativeDuration: 0.5/1.5, animations: {
                self.loginButton.alpha = 1.0
                self.registerButton.alpha = 1.0
            })
        }, completion: nil)
    }
}

