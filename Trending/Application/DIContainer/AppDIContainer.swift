//
//  AppDIContainer.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//

import Foundation
import UIKit
final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          queryParameters: [
                                            "language": NSLocale.preferredLanguages.first ?? "en"])
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    
    
    // MARK: - DIContainers of ReposList
    func makeReposDIContainer() -> ReposListDIContainer {
        let dependencies = ReposListDIContainer.Dependencies(apiDataTransferService: apiDataTransferService
        )
        return ReposListDIContainer(dependencies: dependencies)
    }
    
    
 
    
}
