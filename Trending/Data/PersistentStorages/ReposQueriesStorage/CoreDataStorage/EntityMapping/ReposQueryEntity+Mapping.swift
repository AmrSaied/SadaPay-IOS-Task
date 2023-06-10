//
//  RepoQueryEntity+Mapping.swift
//  Trending
//
//  Created by Amr Saied
//

import Foundation
import CoreData

extension RepoQueryEntity {
    convenience init(repoQuery: RepoQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = repoQuery.q
        sort = repoQuery.sort
        createdAt = Date()
    }
}

extension RepoQueryEntity {
    func toDomain() -> RepoQuery {
        return .init(q: query ?? "" , sort: sort ?? "")
    }
}
