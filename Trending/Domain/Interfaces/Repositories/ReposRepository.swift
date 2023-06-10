//
//  ReposRepository.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//

import Foundation
protocol ReposRepository {
    @discardableResult
    func fetchReposList(query: RepoQuery, page: Int,
                         cached: @escaping (ReposPage) -> Void,
                         completion: @escaping (Result<ReposPage, Error>) -> Void) -> Cancellable?
}
