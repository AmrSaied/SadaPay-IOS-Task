//
//  APIEndpoints.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//

import Foundation
struct APIEndpoints {
    
    static func getRepos(with reposRequestDTO: ReposRequestDTO) -> Endpoint<ReposResponseDTO> {
        return Endpoint(path: "search/repositories",
                        method: .get,
                        queryParametersEncodable: reposRequestDTO)
    }
    
    
}
