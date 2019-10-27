//
//  RecentAnswersViewModel.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/23/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

class RecentAnswersViewModel {

    private let activityModel: AnswersModel

    init(activityModel: AnswersModel) {
        self.activityModel = activityModel
    }

    func deleteItems(atIndexPaths indexPaths: [IndexPath]) {
        activityModel.deleteRecentAnswers(atIndexPath: indexPaths)
    }

    func recentAnswerAtIndex(indexPath: IndexPath) -> PresentableResponse {
        let answer = activityModel.recentAnswerAtIndex(indexPath: indexPath)
        let output = PresentableResponse(data: answer)
        return output
    }

    func numberOfRows() -> Int {
        let quantity = activityModel.numberOfRowsForRecentAnswers()
        return quantity
    }
}
