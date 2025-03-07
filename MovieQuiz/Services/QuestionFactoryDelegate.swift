//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Акимов on 24.09.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {              
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
