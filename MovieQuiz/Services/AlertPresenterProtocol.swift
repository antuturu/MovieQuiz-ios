//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Александр Акимов on 25.09.2023.
//

import Foundation

protocol AlertPresenterProtocol{
    var delegate: AlertPresenterDelegate? {get set}
    
    func requestAlert()
}
