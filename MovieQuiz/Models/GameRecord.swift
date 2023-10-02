//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Александр Акимов on 28.09.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
