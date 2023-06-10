//
//  ReposResponseStorage.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//

import Foundation
protocol ReposResponseStorage {
    func getResponse(for request: ReposRequestDTO, completion: @escaping (Result<ReposResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: ReposResponseDTO, for requestDto: ReposRequestDTO)
}
