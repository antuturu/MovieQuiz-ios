//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Акимов on 25.09.2023.
//

import Foundation
import UIKit

class AlertPresenter {
    static func presentAlert(with model: AlertModel, from viewController: UIViewController) {
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            print("nenen")
            model.completion()
        }
        
        alertController.addAction(action)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

