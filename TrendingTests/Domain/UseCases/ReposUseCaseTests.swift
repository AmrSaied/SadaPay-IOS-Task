//
//  ReposUseCaseTests.swift
//
//  Created Amr Saied
//

import XCTest

class ReposUseCaseTests: XCTestCase {
    
    static let reposPages: [ReposPage] = {
        let page1 = ReposPage(totalCount: 100, incompleteResults: false, repos: [ Repo.stub(id: "id",name: "name", description: "description",ownerImageUrl: "ownerImageUrl", ownerLogin: "ownerLogin", language: "language", stargazersCount: 10)])
        
        let page2 = ReposPage(totalCount: 200, incompleteResults: false, repos: [ Repo.stub(id: "id2",name: "name2", description: "description2",ownerImageUrl: "ownerImageUrl", ownerLogin: "ownerLogin", language: "language", stargazersCount: 10)])
        
        return [page1, page2]
    }()
    
    enum ReposRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    class ReposQueriesRepositoryMock: ReposQueriesRepository {
        var recentQueries: [RepoQuery] = []
        
        func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[RepoQuery], Error>) -> Void) {
            completion(.success(recentQueries))
        }
        func saveRecentQuery(query: RepoQuery, completion: @escaping (Result<RepoQuery, Error>) -> Void) {
            recentQueries.append(query)
        }
    }
    
    struct ReposRepositoryMock: ReposRepository {
        var result: Result<ReposPage, Error>
        func fetchReposList(query: RepoQuery, page: Int, cached: @escaping (ReposPage) -> Void, completion: @escaping (Result<ReposPage, Error>) -> Void) -> Cancellable? {
            completion(result)
            return nil
        }
    }
    
    func testReposUseCase_whenSuccessfullyFetchesReposForQuery_thenQueryIsSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query saved")
        expectation.expectedFulfillmentCount = 2
        let reposQueriesRepository = ReposQueriesRepositoryMock()
        let useCase = DefaultReposUseCase(reposRepository: ReposRepositoryMock(result: .success(ReposUseCaseTests.reposPages[0])),
                                                 reposQueriesRepository: reposQueriesRepository)

        // when
        let requestValue = ReposUseCaseRequestValue(query: RepoQuery(q: "title1" ,sort: "top"),
                                                           page: 0)
        _ = useCase.execute(requestValue: requestValue, cached: { _ in }) { _ in
            expectation.fulfill()
        }
        // then
        var recents = [RepoQuery]()
        reposQueriesRepository.fetchRecentsQueries(maxCount: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(recents.contains(RepoQuery(q: "title1",sort: "top")))
    }
    
    func testReposUseCase_whenFailedFetchingReposForQuery_thenQueryIsNotSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query should not be saved")
        expectation.expectedFulfillmentCount = 2
        let reposQueriesRepository = ReposQueriesRepositoryMock()
        let useCase = DefaultReposUseCase(reposRepository: ReposRepositoryMock(result: .failure(ReposRepositorySuccessTestError.failedFetching)),
                                                 reposQueriesRepository: reposQueriesRepository)
        
        // when
        let requestValue = ReposUseCaseRequestValue(query: RepoQuery(q: "title1",sort: "top"),
                                                           page: 0)
        _ = useCase.execute(requestValue: requestValue, cached: { _ in }) { _ in
            expectation.fulfill()
        }
        // then
        var recents = [RepoQuery]()
        reposQueriesRepository.fetchRecentsQueries(maxCount: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(recents.isEmpty)
    }
}
