//
//  RepoFlowCoordinator.swift
//  Trending
//
//  Created by Amr Saied on 04/03/2023.
//

import Foundation
import UIKit

protocol ReposFlowCoordinatorDependencies  {
    func makeReposListViewController(actions: ReposListViewModelActions) -> ReposListViewController
 
}

final class ReposFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: ReposFlowCoordinatorDependencies

    private weak var reposListVC: ReposListViewController?
    private weak var reposQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: ReposFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = ReposListViewModelActions(showRepoDetails: showRepoDetails
                                    )
        let vc = dependencies.makeReposListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        reposListVC = vc
    }

    private func showRepoDetails(repo: Repo) {
    
        
    }


    
}
