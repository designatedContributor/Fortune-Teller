//
//  AnswerHistoryViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/19/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import SnapKit

class AnswerHistoryViewController: UIViewController {

    private var collectionView: UICollectionView?
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

// swiftlint:disable line_length
//    private lazy var editButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(title: L10n.edit, style: .plain, target: self, action: #selector(editButtonTapped))
//        navigationItem.setRightBarButton(button, animated: true)
//        return button
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        collectionView?.register(AnswerHistoryCell.self, forCellWithReuseIdentifier: AnswerHistoryCell.cellID)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInset = sectionInsets
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension AnswerHistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

// swiftlint:disable line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerHistoryCell.cellID, for: indexPath) as? AnswerHistoryCell else { return UICollectionViewCell() }
        return cell
    }
}

extension AnswerHistoryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
