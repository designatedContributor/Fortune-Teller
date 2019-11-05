//
//  UserDefaultService.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/19/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

final class UserDefaultService: NSObject, UserDefaultsClient {

    private var userAnswers: [UserDefaultsAnswer] = []

    override init() {
        super.init()
        loadAnswers()
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
        let identifier = UUID().uuidString
        let savingItem = UserDefaultsAnswer(answer: answer.answer,
                                            type: answer.type,
                                            date: answer.date,
                                            identifier: identifier)
        userAnswers.append(savingItem)

        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(userAnswers)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print(error.localizedDescription)
        }
    }

    func delete(atIndex indexPaths: [IndexPath]) {
        let sorted = indexPaths.sorted(by: >)
        for item in sorted {
            userAnswers.remove(at: item.row)
        }
    }

    func numberOfRows() -> Int {
        return userAnswers.count
    }

    func objectAtIndex(at indexPath: IndexPath) -> UserDefaultsAnswer {
        return userAnswers[indexPath.row]
    }

    // MARK: Loading data
    func loadAnswers() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                userAnswers = try decoder.decode([UserDefaultsAnswer].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
