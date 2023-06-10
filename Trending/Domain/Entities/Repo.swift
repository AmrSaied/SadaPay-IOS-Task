//
//  Repo.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//

import Foundation
struct Repo: Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let name: String
    let description: String
    let ownerImageUrl: String
    let ownerLogin: String
    let language: String?
    let stargazersCount: Int?
}

struct ReposPage: Equatable {
    let totalCount: Int
    let incompleteResults: Bool
    let repos: [Repo]
}
