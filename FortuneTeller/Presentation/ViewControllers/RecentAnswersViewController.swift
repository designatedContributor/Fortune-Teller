//
//  AnswerHistoryViewController.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 10/19/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import UIKit
import SnapKit

class RecentAnswersViewController: UIViewController {

    var recentViewModel: RecentAnswersViewModel!

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = Asset.background.color
        collection.contentInset = sectionInsets
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: L10n.edit,
                                     style: .plain,
                                     target: self,
                                     action: #selector(editButtonTapped))
        return button
    }()

    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteSelectedItems))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        deleteButton.isEnabled = false
        collectionView.register(AnswerHistoryCell.self, forCellWithReuseIdentifier: AnswerHistoryCell.cellID)
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        setEditing(false, animated: true)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            collectionView.deselectItem(at: indexPath, animated: false)
            guard let cell = collectionView.cellForItem(at: indexPath) as? AnswerHistoryCell else { return }
            cell.isEditing = editing
        }
    }

    @objc func editButtonTapped() {
        self.setEditing(!isEditing, animated: true)
        changeTitle()
        tabBarController?.tabBar.isHidden = isEditing
        deleteButton.isEnabled = isEditing
    }

    @objc func deleteSelectedItems() {
//        guard let indexPaths = collectionView.indexPathsForSelectedItems else { return }
//        self.collectionView.performBatchUpdates({
//            recentViewModel.deleteItems(atIndexPaths: indexPaths)
//            collectionView.deleteItems(at: indexPaths)
//        })
//        self.collectionView.reloadData()
    }

    private func changeTitle() {
        if isEditing && collectionView.numberOfItems(inSection: 0) != 0 {
            editButton.title = L10n.done
        } else {
            editButton.title = L10n.edit
        }
    }
    private func setupCollectionView() {
        view.addSubview(collectionView)
        navigationItem.setLeftBarButton(editButton, animated: true)
        navigationItem.setRightBarButton(deleteButton, animated: true)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension RecentAnswersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentViewModel.numberOfRows()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = recentViewModel.recentAnswerAtIndex(indexPath: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerHistoryCell.cellID, for: indexPath) as? AnswerHistoryCell else { return UICollectionViewCell() }
        cell.item = item
        return cell
    }
}

extension RecentAnswersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
