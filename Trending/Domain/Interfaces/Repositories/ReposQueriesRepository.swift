//
//  ReposQueriesRepository.swift
//  Trending
//
//  Created by Amr Saied on 04/03/2023.
//

import Foundation
protocol ReposQueriesRepository {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[RepoQuery], Error>) -> Void)
    func saveRecentQuery(query: RepoQuery, completion: @escaping (Result<RepoQuery, Error>) -> Void)
}
