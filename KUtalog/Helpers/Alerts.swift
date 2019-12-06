//
//  Alerts.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

enum AlertMessages: String {
    case registrationFailed = "User registration failed."
    case registrationSucceeded = "User account has been created."
    case loginFailed = "Provied credentials are invalid."
    case fieldsEmpty = "E-mail or password field can't be empty."
    case sendResetFailed = "No accounts found for this email address."
    case sendResetSuccess = "Reset link successfully sent."
    case postShareFailed = "Error occured whle sharing your post."
}

func createErrorAlert(message: AlertMessages, error: Error?) -> UIAlertController {
    if let error = error {
        let alert = UIAlertController(title: "Aw, Snap!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    } else {
        let alert = UIAlertController(title: "Aw, Snap!", message: message.rawValue, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
           return alert
    }
}


func createSuccessAlert(message: AlertMessages) -> UIAlertController{
    let alert = UIAlertController(title: "Success!", message: message.rawValue, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    return alert
}
