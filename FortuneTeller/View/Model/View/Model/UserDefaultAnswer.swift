//
//  AnswerBank.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/19/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

final class UserDefaultAnswer {

    var userAnswers = [Response(answer: "I believe in you", type: .affirmative),
                       Response(answer: "Don't mind", type: .neutral),
                       Response(answer: "Bad idea", type: .contrary)]

    func getRandomAnswer() -> (answer: String, type: AnswerType) {
        let answer = userAnswers.randomElement()
        let element = (answer!.answer, answer!.type)
        return element
    }

    func isAnswerSaved(answer: String) -> Bool {
        let isAnswerSaved = userAnswers.contains { $0.answer == answer }
        return isAnswerSaved
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
    func save(answer: String, type: AnswerType) {

        let savingItem = Response(answer: answer, type: type)
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
                userAnswers = try decoder.decode([Response].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
