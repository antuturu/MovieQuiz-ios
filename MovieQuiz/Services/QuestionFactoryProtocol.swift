//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Александр Акимов on 24.09.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? {get set}
    func requestNextQuestion()
}
