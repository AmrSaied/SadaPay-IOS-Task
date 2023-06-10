//
//  ReposRequestDTO.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//

import Foundation
struct ReposRequestDTO: Encodable {
    let q: String
    let sort: String
    let page: Int

    
    
}
