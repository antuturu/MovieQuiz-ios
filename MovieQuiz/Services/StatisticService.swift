//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Александр Акимов on 27.09.2023.
//

import Foundation

protocol StatisticService {
    
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    func store(correct count: Int, total amount: Int)
    
}

final class StatisticServiceImplementation: StatisticService {
    
    var totalAccuracy: Double{
        Double(correct) / Double(total) * 100
    }
    
    private let userDefaults = UserDefaults.standard
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }

        set {

            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }

        set {

            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }

        set {

            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord? {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        self.correct = count
        self.total = amount
        self.gamesCount += 1
        print(correct)
        print(total)
        let currentBestGame = GameRecord(correct: correct, total: total, date: Date())
        
        if let previousBestGame = bestGame{
            if previousBestGame.correct < currentBestGame.correct {
                bestGame = currentBestGame
            }
        }else {
            bestGame = currentBestGame
        }
    }
}
