//
//  CatService.swift
//  CombineHomework
//
//  Created by Ruslan Khanov on 14.11.2021.
//

import Foundation
import Combine


final class CatService {

    // MARK: - Instance properties

    @Published var counter: Int = 0

    var publisher: AnyPublisher<CatFact, Never> {
        subject.eraseToAnyPublisher()
    }

    private let subject = PassthroughSubject<CatFact, Never>()

    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private var cancellable: AnyCancellable?

    private var url: URL {
        guard let url = URL(string: "https://catfact.ninja/fact") else {
            fatalError("Base url is not configured")
        }

        return url
    }

    // MARK: - Instance methods

    func fetchData() {
        cancellable = session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CatFact?.self, decoder: decoder)
            .replaceError(with: nil)
            .compactMap { $0 }
            .sink { [weak self] in
                self?.counter += 1
                self?.subject.send($0)
            }
    }
}
