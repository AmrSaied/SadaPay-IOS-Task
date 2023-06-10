//
//  ReposListItemViewModel.swift
//  Trending
//
//  Created by Amr Saied on 04/03/2023.
//

import Foundation
 

struct ReposListItemViewModel: Equatable {
    let name: String
    let description: String
    let ownerImageUrl: String
    let ownerLogin: String
    let language: String?
    let stargazersCount: Int?
    var isExpanded = false
}

extension ReposListItemViewModel {

    init(repo: Repo) {
        self.name = repo.name
        self.description = repo.description
        self.ownerImageUrl = repo.ownerImageUrl
        self.ownerLogin = repo.ownerLogin
        self.language = repo.language ?? ""
        self.stargazersCount = repo.stargazersCount  
    }
}

 
