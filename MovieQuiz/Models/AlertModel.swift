//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Александр Акимов on 25.09.2023.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
