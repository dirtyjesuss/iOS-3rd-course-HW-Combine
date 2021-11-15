//
//  ViewController.swift
//  CombineHomework
//
//  Created by Ruslan Khanov on 14.11.2021.
//

import UIKit
import SnapKit
import Combine

class ViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        enum SegmentedControl {
            static let topOffset: CGFloat = 27
            static let height: CGFloat = 32
            static let horizontalInset: CGFloat = 90
            static let items: [String] = [Text.cats, Text.dogs]
        }

        enum NavigationBar {
            static let shadowOffset = CGSize(width: 0, height: 0.5)
            static let shadowOpacity: Float = 0.3
        }

        enum ContentView {
            static let horizontalInset: CGFloat = 18
            static let topOffset: CGFloat = 40
            static let height: CGFloat = 205
        }

        enum MoreButton {
            static let topOffset: CGFloat = 13
            static let height: CGFloat = 40
            static let wight: CGFloat = 144
            static let cornerRadius: CGFloat = 20
        }

        enum ScoreLabel {
            static let topOffset: CGFloat = 35
        }
    }

    // MARK: - Instance properties

    private var cancellables: [AnyCancellable] = []

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: Constants.SegmentedControl.items)
        control.backgroundColor = Color.lightFillGray

        return control
    }()

    private let contentView: ContentView = ContentView()

    private let moreButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.MoreButton.cornerRadius
        button.layer.backgroundColor = Color.lightOrange.cgColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle(Text.moreButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(moreButtonOnTap), for: .touchUpInside)

        return button
    }()

    private let scoreLabel: ScoreLabel = ScoreLabel()

    private let catService = CatService()

    // MARK: - Instance methods

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupNavigationBar()
        setupSubviews()
        setupSubscriptions()
    }

    private func setupNavigationBar() {
        title = Text.title
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = Color.lightGray

        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = Constants.NavigationBar.shadowOffset
        navigationController?.navigationBar.layer.shadowRadius = .zero
        navigationController?.navigationBar.layer.shadowOpacity = Constants.NavigationBar.shadowOpacity

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Text.resetButtonTitle,
            style: .plain,
            target: self,
            action: nil
        )
    }

    private func setupSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(contentView)
        view.addSubview(moreButton)
        view.addSubview(scoreLabel)

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.SegmentedControl.topOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.SegmentedControl.horizontalInset)
            make.height.equalTo(Constants.SegmentedControl.height)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(Constants.ContentView.topOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.ContentView.horizontalInset)
            make.height.equalTo(Constants.ContentView.height)
        }

        moreButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(Constants.MoreButton.topOffset)
            make.height.equalTo(Constants.MoreButton.height)
            make.width.equalTo(Constants.MoreButton.wight)
            make.centerX.equalToSuperview()
        }

        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(moreButton.snp.bottom).offset(Constants.ScoreLabel.topOffset)
            make.centerX.equalToSuperview()
        }
    }

    private func setupSubscriptions() {
        catService.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] catFact in
                self?.contentView.configure(with: catFact.fact)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc private func moreButtonOnTap() {
        catService.fetchData()
    }
}

