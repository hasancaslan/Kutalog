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

func createSuccessAlert(message: AlertMessages) -> UIAlertController {
    let alert = UIAlertController(title: "Success!", message: message.rawValue, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    return alert
}

enum ClassError: Error {
    case urlError
    case networkUnavailable
    case wrongDataFormat
    case missingData
    case creationError
    case conflictCourseError
    case courseTimeDoesNotExistError
}

extension ClassError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("Could not create a URL.", comment: "")
        case .networkUnavailable:
            return NSLocalizedString("Could not get data from the remote server.", comment: "")
        case .wrongDataFormat:
            return NSLocalizedString("Could not digest the fetched data.", comment: "")
        case .missingData:
            return NSLocalizedString("Found and will discard a module missing a valid data.", comment: "")
        case .creationError:
            return NSLocalizedString("Failed to create a new Quake object.", comment: "")
        case .conflictCourseError:
            return NSLocalizedString("There is conflict with another course in your schedule.", comment: "")
        case .courseTimeDoesNotExistError:
            return NSLocalizedString("Course time does not exist in the API.", comment: "")
        }
    }
}
