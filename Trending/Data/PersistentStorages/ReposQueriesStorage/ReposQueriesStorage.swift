//
//  ReposQueriesStorage.swift
//  Trending
//
//  Created by Amr Saied
//

import Foundation

protocol ReposQueriesStorage {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[RepoQuery], Error>) -> Void)
    func saveRecentQuery(query: RepoQuery, completion: @escaping (Result<RepoQuery, Error>) -> Void)
}
