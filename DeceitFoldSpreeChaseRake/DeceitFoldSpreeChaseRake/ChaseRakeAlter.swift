//
//  Utils.swift
//  DeceitFoldSpreeChaseRake
//
//  Created by DeceitFoldSpree ChaseRake on 2025/3/10.
//

import UIKit

class ChaseRakeAlter {
    static func showAlert(title: String, message: String, from viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
