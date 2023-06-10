//
//  Repo+Stub.swift
//  Trending
//
//  Created by ِAmr Saied
//

import Foundation

extension Repo {
    static func stub(id: Repo.Identifier = "id1",
                name: String = "name" ,
                     description: String = "description" ,
                     ownerImageUrl: String = "ownerImageUrl" ,
                     ownerLogin: String = "ownerLogin" ,
                     language: String = "language" ,
                     stargazersCount: Int =  10
    
    
    ) -> Self {
        Repo(id: id,
             name: name,
             description: description,
             ownerImageUrl: ownerImageUrl,
             ownerLogin: ownerLogin,
             language: language,
             stargazersCount:stargazersCount
        )
    }
}
