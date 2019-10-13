//
//  SettingsViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/11/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)

    var settingsViewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.frame
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(AnswerHistoryCell.self, forCellReuseIdentifier: "AnswerHistoryCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsViewModel.loadAnswers()
        tableView.reloadData()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let attemts = settingsViewModel.getAttemts()
            cell.textLabel?.text = "Lifetime application predictions: \(attemts)"
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            return cell
        }

        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Create custom answer"
            return cell
        }

        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerHistoryCell", for: indexPath) as? AnswerHistoryCell else { return UITableViewCell() }

            let answers = settingsViewModel.getAnswers()
            cell.textLabel?.text = answers[indexPath.row].answer
            cell.detailTextLabel?.text = settingsViewModel.format(date: answers[indexPath.row].date)
            switch answers[indexPath.row].type {
            case .affirmative: cell.typeView.backgroundColor = ColorName.affirmative.color
            case .neutral: cell.typeView.backgroundColor = ColorName.neutral.color
            case .contrary: cell.typeView.backgroundColor = ColorName.contrary.color
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Answer history"
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return settingsViewModel.getAnswers().count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let controller = SaveAnswerViewController()
            controller.settingsViewModel = self.settingsViewModel
            settingsViewModel.delegate = controller
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
