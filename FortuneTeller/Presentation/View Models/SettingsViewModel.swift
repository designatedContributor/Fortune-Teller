//
//  SettingsViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 9/29/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewModel: NSObject {

    weak var delegate: SettingsViewModelDelegate!

    lazy var formatted: [String] = {
        return toString()
    }()

    private let activityModel: AnswersModel

    init(activityModel: AnswersModel) {
        self.activityModel = activityModel
    }

    func saveAnswer(input: PresentableResponse) {
        let item = AnswersData(answer: input.answer, type: input.type.rawValue, date: Date())
        let isAnswerSaved = activityModel.isSaved(answer: item)
        if isAnswerSaved == false && !input.answer.isEmpty {
            activityModel.saveAnswer(answer: item)
            delegate.didSaveAlert()
        } else {
            delegate.errorAlert()
        }
    }

    func getAnswers() -> [PresentableResponse] {
        let answers = activityModel.getSavedAnswers()
        let result = answers.map {
            PresentableResponse(data: $0)
        }
        return result
    }

    func loadAnswers() {
        activityModel.loadSavedAnswers()
    }

    func getAttemts() -> String {
        let result = String(activityModel.retrieveAttemts())
        return result
    }

    private func toString() -> [String] {
        let input = AnswerType.allCases
        let output = input.map { $0.rawValue }
        return output
    }
}

//swiftlint:disable line_length
extension SettingsViewModel: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            let attemts = getAttemts()
            cell.textLabel?.text = L10n.lifetimeApplicationPredictions + "\(attemts)"
            cell.selectionStyle = .none
            cell.backgroundColor = Asset.tabbar.color
            cell.textLabel?.textColor = ColorName.white.color
            cell.isUserInteractionEnabled = false
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = Asset.tabbar.color
            let selectionView = UIView()
            selectionView.backgroundColor = Asset.selected.color
            cell.selectedBackgroundView = selectionView
            cell.textLabel?.textColor = Asset.buttonColor.color
            cell.textLabel?.text = L10n.createCustomAnswer
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerHistoryCell.cellID, for: indexPath) as? AnswerHistoryCell else { return UITableViewCell() }
            let answers = getAnswers()
            cell.item = answers[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return L10n.answerHistory
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return getAnswers().count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let answers = getAnswers()
            let answerToRemove = answers[indexPath.row].identifier
            activityModel.deleteItem(withID: answerToRemove)
            activityModel.loadSavedAnswers()
        }
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}
