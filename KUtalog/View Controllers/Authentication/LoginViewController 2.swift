//
//  LoginViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: MadokaTextField!
    @IBOutlet weak var passwordField: MadokaTextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.layer.cornerRadius = 55/2
    }

    // MARK: - Actions
    @IBAction func loginTapped(_ sender: Any) {
        let activityIndicator: UIActivityIndicatorView = {
            let activity = UIActivityIndicatorView(style: .gray)
            activity.translatesAutoresizingMaskIntoConstraints = false
            activity.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activity.startAnimating()
            return activity
        }()
        loginButton.setTitle(nil, for: .normal)
        loginButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true

        guard let email = emailField.text, let password = passwordField.text else {
            let alert = createErrorAlert(message: .fieldsEmpty, error: nil)
            self.present(alert, animated: true, completion: nil)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) {[unowned self] (user, err) in
            if err != nil {
                activityIndicator.stopAnimating()
                self.loginButton.setTitle("Log In", for: .normal)
                activityIndicator.removeFromSuperview()
                let alert = createErrorAlert(message: .loginFailed, error: nil)
                self.present(alert, animated: true, completion: nil)
                return
            }

            let uid = user?.user.uid
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
            UserDefaults.standard.set(uid, forKey: "uid")

            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = controller
        }
    }
}
