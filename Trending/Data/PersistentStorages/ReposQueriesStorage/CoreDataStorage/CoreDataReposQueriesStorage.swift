//
//  CoreDataReposQueriesStorage.swift
//  Trending
//
//  Created by Amr Saied
//

import Foundation
import CoreData

final class CoreDataReposQueriesStorage {

    private let maxStorageLimit: Int
    private let coreDataStorage: CoreDataStorage

    init(maxStorageLimit: Int, coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.maxStorageLimit = maxStorageLimit
        self.coreDataStorage = coreDataStorage
    }
}

extension CoreDataReposQueriesStorage: ReposQueriesStorage {
    
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[RepoQuery], Error>) -> Void) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = RepoQueryEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(RepoQueryEntity.createdAt),
                                                            ascending: false)]
                request.fetchLimit = maxCount
                let result = try context.fetch(request).map { $0.toDomain() }

                completion(.success(result))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func saveRecentQuery(query: RepoQuery, completion: @escaping (Result<RepoQuery, Error>) -> Void) {

        coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            do {
                try self.cleanUpQueries(for: query, inContext: context)
                let entity = RepoQueryEntity(repoQuery: query, insertInto: context)
                try context.save()

                completion(.success(entity.toDomain()))
            } catch {
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        }
    }
}

// MARK: - Private
extension CoreDataReposQueriesStorage {

    private func cleanUpQueries(for query: RepoQuery, inContext context: NSManagedObjectContext) throws {
        let request: NSFetchRequest = RepoQueryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(RepoQueryEntity.createdAt),
                                                    ascending: false)]
        var result = try context.fetch(request)

        removeDuplicates(for: query, in: &result, inContext: context)
        removeQueries(limit: maxStorageLimit - 1, in: result, inContext: context)
    }

    private func removeDuplicates(for query: RepoQuery, in queries: inout [RepoQueryEntity], inContext context: NSManagedObjectContext) {
        queries
            .filter { $0.query == query.q  && $0.sort == query.sort }
            .forEach { context.delete($0) }
        queries.removeAll { $0.query == query.q && $0.sort == query.sort   }
    }

    private func removeQueries(limit: Int, in queries: [RepoQueryEntity], inContext context: NSManagedObjectContext) {
        guard queries.count > limit else { return }

        queries.suffix(queries.count - limit)
            .forEach { context.delete($0) }
    }
}
