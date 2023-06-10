//
//  ReposResponseEntity+Mapping.swift
//  Treding
//
//  Created by Amr Saied
//

import Foundation
import CoreData

extension ReposResponseEntity {
    func toDTO() -> ReposResponseDTO {
        return  .init(totalCount: Int(totalCount), incompleteResults: incompleteResults, repos: repos?.allObjects.map { ($0 as! RepoResponseEntity).toDTO()} ?? [])
    }
}

extension RepoResponseEntity {
    func toDTO() -> ReposResponseDTO.RepoDTO {
        return   .init(id: Int(id), description: descriptions ?? "", name: name ?? "", language: language, stargazersCount: Int(stargazersCount), owner: ReposResponseDTO.Owner(id: Int(owner_id), login: owner_login ?? "", avatarURL: owner_image_url ?? ""))
    }
}

extension ReposRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> ReposRequestEntity {
        let entity: ReposRequestEntity = .init(context: context)
        entity.q = q
        entity.sort = sort
        entity.page = Int32(page)
        return entity
    }
}

extension ReposResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> ReposResponseEntity {
        let entity: ReposResponseEntity = .init(context: context)
        entity.totalCount = Int32(totalCount)
        entity.incompleteResults = incompleteResults
        repos.forEach {
            entity.addToRepos($0.toEntity(in: context))
        }
        return entity
    }
}

extension ReposResponseDTO.RepoDTO {
    func toEntity(in context: NSManagedObjectContext) -> RepoResponseEntity {
        let entity: RepoResponseEntity = .init(context: context)
        entity.id = Int64(id)
        entity.descriptions = description
        entity.language = language
        entity.owner_id = Int64(owner.id)
        entity.owner_login = owner.login
        entity.owner_image_url = owner.avatarURL
        entity.name = name
        entity.stargazersCount = Int64(stargazersCount)
        entity.name = name
        return entity
    }
}
