//
//  UserDefaultsReposQueriesStorage.swift
//  Trending
//
//  Created by Amr Saied
//

import Foundation

final class UserDefaultsReposQueriesStorage {
    private let maxStorageLimit: Int
    private let recentsReposQueriesKey = "recentsReposQueries"
    private var userDefaults: UserDefaults
    
    init(maxStorageLimit: Int, userDefaults: UserDefaults = UserDefaults.standard) {
        self.maxStorageLimit = maxStorageLimit
        self.userDefaults = userDefaults
    }

    private func fetchReposQuries() -> [RepoQuery] {
        if let queriesData = userDefaults.object(forKey: recentsReposQueriesKey) as? Data {
            if let repoQueryList = try? JSONDecoder().decode(RepoQueriesListUDS.self, from: queriesData) {
                return repoQueryList.list.map { $0.toDomain() }
            }
        }
        return []
    }

    private func persist(reposQuries: [RepoQuery]) {
        let encoder = JSONEncoder()
        let repoQueryUDSs = reposQuries.map(RepoQueryUDS.init)
        if let encoded = try? encoder.encode(RepoQueriesListUDS(list: repoQueryUDSs)) {
            userDefaults.set(encoded, forKey: recentsReposQueriesKey)
        }
    }
}

extension UserDefaultsReposQueriesStorage: ReposQueriesStorage {

    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[RepoQuery], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchReposQuries()
            queries = queries.count < self.maxStorageLimit ? queries : Array(queries[0..<maxCount])
            completion(.success(queries))
        }
    }

    func saveRecentQuery(query: RepoQuery, completion: @escaping (Result<RepoQuery, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchReposQuries()
            self.cleanUpQueries(for: query, in: &queries)
            queries.insert(query, at: 0)
            self.persist(reposQuries: queries)

            completion(.success(query))
        }
    }
}


// MARK: - Private
extension UserDefaultsReposQueriesStorage {

    private func cleanUpQueries(for query: RepoQuery, in queries: inout [RepoQuery]) {
        removeDuplicates(for: query, in: &queries)
        removeQueries(limit: maxStorageLimit - 1, in: &queries)
    }

    private func removeDuplicates(for query: RepoQuery, in queries: inout [RepoQuery]) {
        queries = queries.filter { $0 != query }
    }

    private func removeQueries(limit: Int, in queries: inout [RepoQuery]) {
        queries = queries.count <= limit ? queries : Array(queries[0..<limit])
    }
}
