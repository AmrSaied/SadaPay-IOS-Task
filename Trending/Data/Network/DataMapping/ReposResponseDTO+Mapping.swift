//
//  ReposResponseDTO+Mapping.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//


import Foundation

// MARK: - ReposResponseDTO
struct ReposResponseDTO: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let repos: [RepoDTO]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case repos = "items"
    }
}
 

extension ReposResponseDTO {
    func toDomain() -> ReposPage {
        return .init(totalCount: totalCount,
                     incompleteResults:incompleteResults,
                     repos: repos.map { $0.toDomain() })
    }
}


extension ReposResponseDTO.RepoDTO {
    func toDomain() -> Repo {
        return .init(id: Repo.Identifier(id),
                     name: name,description: description ?? "" ,ownerImageUrl: owner.avatarURL
                     ,ownerLogin: owner.login,language: language,stargazersCount: stargazersCount
                   )
    }
}


extension ReposResponseDTO {
    
    // MARK: - Repos
    struct RepoDTO: Codable {
        let id: Int
        let description :String?
        let name :String
        let language: String?
        let stargazersCount: Int
        let owner: Owner

        
        enum CodingKeys: String, CodingKey {
            case id
            case description = "description"
            case name
            case language = "language"
            case stargazersCount = "stargazers_count"
            case owner
          
        }
    }
 
    
    // MARK: - Owner
    struct Owner: Codable {
        let id : Int
        let login: String
        let avatarURL: String
       
        
        enum CodingKeys: String, CodingKey {
            case login, id
             case avatarURL = "avatar_url"
        
        }
    }
 
}
