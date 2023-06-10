//
//  DefaultReposQueriesRepository.swift
//  Trending
//
//  Created by Amr Saied on 04/03/2023.
//

import Foundation


import Foundation

final class DefaultReposQueriesRepository {
    
    private let dataTransferService: DataTransferService
    private var reposQueriesPersistentStorage: ReposQueriesStorage
    
    init(dataTransferService: DataTransferService,
         reposQueriesPersistentStorage: ReposQueriesStorage) {
        self.dataTransferService = dataTransferService
        self.reposQueriesPersistentStorage = reposQueriesPersistentStorage
    }
}

extension DefaultReposQueriesRepository: ReposQueriesRepository {
    
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[RepoQuery], Error>) -> Void) {
        return reposQueriesPersistentStorage.fetchRecentsQueries(maxCount: maxCount, completion: completion)
    }
    
    func saveRecentQuery(query: RepoQuery, completion: @escaping (Result<RepoQuery, Error>) -> Void) {
        reposQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
}
