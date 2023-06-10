//
//  ReposUseCase.swift
//  Trending
//
//  Created by Amr Saied on 04/03/2023.
//

import Foundation
protocol ReposUseCase {
    func execute(requestValue: ReposUseCaseRequestValue,
                 cached: @escaping (ReposPage) -> Void,
                 completion: @escaping (Result<ReposPage, Error>) -> Void) -> Cancellable?
}

final class DefaultReposUseCase: ReposUseCase {

    private let ReposRepository: ReposRepository
    private let ReposQueriesRepository: ReposQueriesRepository

    init(reposRepository: ReposRepository,
         reposQueriesRepository: ReposQueriesRepository) {

        self.ReposRepository = reposRepository
        self.ReposQueriesRepository = reposQueriesRepository
    }

    func execute(requestValue: ReposUseCaseRequestValue,
                 cached: @escaping (ReposPage) -> Void,
                 completion: @escaping (Result<ReposPage, Error>) -> Void) -> Cancellable? {

        return ReposRepository.fetchReposList(query: requestValue.query,
                                                page: requestValue.page,
                                                cached: cached,
                                                completion: { result in

            if case .success = result {
                self.ReposQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
            }

            completion(result)
        })
    }
}

struct ReposUseCaseRequestValue {
    let query:  RepoQuery
    let page: Int
}
