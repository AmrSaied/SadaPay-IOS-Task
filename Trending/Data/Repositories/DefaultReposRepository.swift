//
//  ReposRepository.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//

import Foundation

final class DefaultReposRepository {

    private let dataTransferService: DataTransferService
    private let cache: ReposResponseStorage

    init(dataTransferService: DataTransferService ,cache :ReposResponseStorage
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache

    }
}

extension DefaultReposRepository: ReposRepository {
 
    
    
    func fetchReposList(query: RepoQuery, page: Int, cached: @escaping (ReposPage) -> Void, completion: @escaping (Result<ReposPage, Error>) -> Void) -> Cancellable? {
        let requestDTO = ReposRequestDTO(q: query.q, sort: query.sort ,page: page )
        let task = RepositoryTask()
        cache.getResponse(for: requestDTO) { result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
            guard !task.isCancelled else { return }
            let endpoint = APIEndpoints.getRepos(with: requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    self.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
    


    
}
