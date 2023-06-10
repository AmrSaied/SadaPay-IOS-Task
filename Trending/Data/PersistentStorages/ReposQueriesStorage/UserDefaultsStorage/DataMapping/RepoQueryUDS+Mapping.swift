//
//  RepoQueryUDS+Mapping.swift
//  Data
//
//  Created Amr Saied
//

import Foundation

struct RepoQueriesListUDS: Codable {
    var list: [RepoQueryUDS]
}

struct RepoQueryUDS: Codable {
    let q: String
    let sort: String
}

extension RepoQueryUDS {
    init(repoQuery: RepoQuery) {
        q = repoQuery.q
        sort = repoQuery.sort
    }
}

extension RepoQueryUDS {
    func toDomain() -> RepoQuery {
        return .init(q: q,sort: sort)
    }
}
