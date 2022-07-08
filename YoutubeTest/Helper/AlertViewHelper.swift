//
//  AlertViewHelper.swift
//  YoutubeTest
//
//  Created by Shamkhal Guliyev on 08.07.22.
//

import UIKit

class AlertViewHelper {
    static func showAlert(title: String = "Error", message: String, style: UIAlertController.Style = .alert) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let close = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alert.addAction(close)
        return alert
    }
}
