//
//  AppFlowCoordinator.swift
//  Trending
//
//  Created by Amr Saied on 04/03/2023.
//

import Foundation
import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let reposSceneDIContainer = appDIContainer.makeReposDIContainer()
        let flow = reposSceneDIContainer.makeReposFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
