//
//  ScoreLabel.swift
//  CombineHomework
//
//  Created by Ruslan Khanov on 14.11.2021.
//

import UIKit

class ScoreLabel: UILabel {

    // MARK: - Constants

    private enum Constants {
        static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }

    // MARK: - Init

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        textAlignment = .center
        font = Constants.font

        configure(cats: .zero, dogs: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods

    func configure(cats: Int, dogs: Int) {
        text = "Score: \(cats) cats and \(dogs) dogs"
    }
}
