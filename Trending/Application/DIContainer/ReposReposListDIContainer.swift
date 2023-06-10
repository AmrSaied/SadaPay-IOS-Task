//
//  ReposDIContainer.swift
//  Trending
//
//  Created by Amr Saied on 03/03/2023.
//

import Foundation
import UIKit

final class ReposListDIContainer: ReposFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
    lazy var reposQueriesStorage: ReposQueriesStorage = CoreDataReposQueriesStorage(maxStorageLimit: 10)
    lazy var reposResponseCache: ReposResponseStorage = CoreDataReposResponseStorage()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeReposUseCase() -> ReposUseCase {
        return DefaultReposUseCase(reposRepository: makeReposRepository(),
                                   reposQueriesRepository: makeReposQueriesRepository())
    }
    
 
    
    // MARK: - Repositories
    func makeReposRepository() -> ReposRepository {
        return DefaultReposRepository(dataTransferService: dependencies.apiDataTransferService, cache: reposResponseCache)
    }
    func makeReposQueriesRepository() -> ReposQueriesRepository {
        return DefaultReposQueriesRepository(dataTransferService: dependencies.apiDataTransferService,
                                              reposQueriesPersistentStorage: reposQueriesStorage)
    }

    
    // MARK: - Repos List
    func makeReposListViewController(actions: ReposListViewModelActions) -> ReposListViewController {
        return ReposListViewController.create(with: makeReposListViewModel(actions: actions))
    }
    
    func makeReposListViewModel(actions: ReposListViewModelActions) -> ReposListViewModel {
        return DefaultReposListViewModel(reposUseCase: makeReposUseCase(),
                                          actions: actions)
    }
    
  
    
    // MARK: - Flow Coordinators
    func makeReposFlowCoordinator(navigationController: UINavigationController) -> ReposFlowCoordinator {
        return ReposFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }


  
}

