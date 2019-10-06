//
//  AnswerBank.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/19/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

final class UserDefaultService: UserDefault {

    var userAnswers = [AnswersStoredData(answer: "I believe in you", type: "Affirmative"),
                       AnswersStoredData(answer: "Don't mind", type: "Neutral"),
                       AnswersStoredData(answer: "Bad idea", type: "Contrary")]

    func isAnswerSaved(answer: AnswersData) -> Bool {
        let toAnswersStoredData = AnswersStoredData(answer: answer.answer, type: answer.type)
        let isAnswerSaved = userAnswers.contains { $0 == toAnswersStoredData }
        return isAnswerSaved
    }

    func getRandomAnswer() -> AnswersData {
        guard let answer = userAnswers.randomElement() else { return AnswersData(answer: "", type: "Affirmative")}
        let result = AnswersData(withStoredAnswer: answer)
        return result
    }

    // MARK: Helper functions to get FilePath
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Fortune-Teller.plist")
    }

    // MARK: Saving data
    func save(answer: AnswersData) {

        let savingItem = AnswersStoredData(answer: answer.answer, type: answer.type)
        userAnswers.append(savingItem)

        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(userAnswers)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: Loading data
    func loadAnswers() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                userAnswers = try decoder.decode([AnswersStoredData].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
