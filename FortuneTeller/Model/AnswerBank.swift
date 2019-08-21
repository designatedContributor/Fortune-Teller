//
//  AnswerBank.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/19/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

protocol AnswerBankProtocol: class {
    var currentAnswers: [ResponseBody] { get set }
}

class AnswerBank {
    
    var delegate: AnswerBankProtocol!
    
    var userAnswers = [ResponseBody(answer: "I believe in you", type: .Affirmative), ResponseBody(answer: "Don't mind", type: .Neutral), ResponseBody(answer: "Bad idea", type: .Contrary)]
    
    func getRandomAnswer() -> (String, Type) {
        let answer = userAnswers.randomElement()
        let element = (answer!.answer, answer!.type)
        return element
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Fortune-Teller.plist")
    }
    
    
    func saveUserAnswer(answer: String, type: Type) {
        
        let savingItem = ResponseBody(answer: answer, type: type)
        userAnswers.append(savingItem)
        delegate.currentAnswers = userAnswers
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(userAnswers)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadAnswers() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                userAnswers = try decoder.decode([ResponseBody].self, from: data)
                delegate.currentAnswers = userAnswers
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
