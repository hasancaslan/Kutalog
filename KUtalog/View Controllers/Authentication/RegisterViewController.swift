//
//  RegisterViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import FirebaseAuth
import TextFieldEffects

class RegisterViewController: UIViewController {
    @IBOutlet weak var passwordField: MadokaTextField!
    @IBOutlet weak var emailField: MadokaTextField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.registerButton.layer.cornerRadius = 55/2
    }

    @IBAction func registerTapped(_ sender: Any) {
        let activityIndicator: UIActivityIndicatorView = {
            let activity = UIActivityIndicatorView(style: .gray)
            activity.translatesAutoresizingMaskIntoConstraints = false
            activity.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activity.startAnimating()
            return activity
        }()
        registerButton.setTitle(nil, for: .normal)
        registerButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor).isActive = true

        guard let email = emailField.text, let password = passwordField.text else {
            let alert = createErrorAlert(message: .fieldsEmpty, error: nil)
            self.present(alert, animated: true, completion: nil)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password, completion: {(authResult, error) in
            guard let user = authResult?.user, error == nil else {
                activityIndicator.stopAnimating()
                self.registerButton.setTitle("Register", for: .normal)
                activityIndicator.removeFromSuperview()
                let alert = createErrorAlert(message: .registrationFailed, error: error)
                self.present(alert, animated: true, completion: nil)
                return
            }

            let uid = user.uid
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
            UserDefaults.standard.set(uid, forKey: "uid")

            let alert = UIAlertController(title: "Your account succesfully created!", message: "You can now start to use KUtalog.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = controller
            }))

            activityIndicator.stopAnimating()
            self.registerButton.setTitle("Register", for: .normal)
            activityIndicator.removeFromSuperview()
            self.present(alert, animated: true, completion: nil)
        })
    }

    @IBAction func textFieldDidChanged(_ sender: Any) {
        if validEmail(email: emailField.text ?? "") && validPassword(password: passwordField.text ?? "") {
                   registerButton.isEnabled = true
                   registerButton.backgroundColor = .white
               } else {
                   registerButton.backgroundColor = .lightGray
                   registerButton.isEnabled = false
               }
    }
}
