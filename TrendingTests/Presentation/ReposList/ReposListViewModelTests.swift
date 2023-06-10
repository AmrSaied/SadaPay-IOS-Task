//
//  ReposListViewModelTests.swift
//  Trending
//
//  Created by  Amr Saied
//

import XCTest

class ReposListViewModelTests: XCTestCase {
    
    private enum SearchReposUseCaseError: Error {
        case someError
    }
    
    let reposPages: [ReposPage] = {
        
        let page1 = ReposPage(totalCount: 100, incompleteResults: false, repos: [ Repo.stub(id: "id",name: "name", description: "description",ownerImageUrl: "ownerImageUrl", ownerLogin: "ownerLogin", language: "language", stargazersCount: 10)])
        
        let page2 = ReposPage(totalCount: 200, incompleteResults: false, repos: [ Repo.stub(id: "id2",name: "name2", description: "description2",ownerImageUrl: "ownerImageUrl", ownerLogin: "ownerLogin", language: "language", stargazersCount: 10)])

        return [page1, page2]
    }()
    
    class ReposUseCaseMock: ReposUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var page = ReposPage(totalCount: 0, incompleteResults: false, repos: [])
        
        func execute(requestValue: ReposUseCaseRequestValue,
                     cached: @escaping (ReposPage) -> Void,
                     completion: @escaping (Result<ReposPage, Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(page))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    func test_whenSearchReposUseCaseRetrievesFirstPage_thenViewModelContainsOnlyFirstPage() {
        // given
        let searchReposUseCaseMock = ReposUseCaseMock()
        searchReposUseCaseMock.expectation = self.expectation(description: "contains only first page")
        searchReposUseCaseMock.page = ReposPage(totalCount: 1, incompleteResults: false, repos:  reposPages[0].repos)
        let viewModel = DefaultReposListViewModel(reposUseCase: searchReposUseCaseMock)
        // when
        viewModel.viewDidLoad()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
    }
    
    func test_whenSearchReposUseCaseRetrievesFirstAndSecondPage_thenViewModelContainsTwoPages() {
        // given
        let searchReposUseCaseMock = ReposUseCaseMock()
        searchReposUseCaseMock.expectation = self.expectation(description: "First page loaded")
        searchReposUseCaseMock.page = ReposPage(totalCount: 1, incompleteResults: false, repos:  reposPages[0].repos)
        let viewModel = DefaultReposListViewModel(reposUseCase: searchReposUseCaseMock)
        // when
        viewModel.viewDidLoad()
        waitForExpectations(timeout: 5, handler: nil)
        
        searchReposUseCaseMock.expectation = self.expectation(description: "Second page loaded")
        searchReposUseCaseMock.page = ReposPage(totalCount: 21, incompleteResults: false, repos:  reposPages[0].repos)
        
        viewModel.didLoadNextPage()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertFalse(viewModel.hasMorePages)
    }
    
    func test_whenSearchReposUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let searchReposUseCaseMock = ReposUseCaseMock()
        searchReposUseCaseMock.expectation = self.expectation(description: "contain errors")
        searchReposUseCaseMock.error = SearchReposUseCaseError.someError
        let viewModel = DefaultReposListViewModel(reposUseCase: searchReposUseCaseMock)
        // when
        viewModel.viewDidLoad()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(viewModel.error)
    }
    
    func test_whenLastPage_thenHasNoPageIsTrue() {
        // given
        let searchReposUseCaseMock = ReposUseCaseMock()
        searchReposUseCaseMock.expectation = self.expectation(description: "First page loaded")
        searchReposUseCaseMock.page = ReposPage(totalCount: 1, incompleteResults: false, repos:  reposPages[0].repos)
        let viewModel = DefaultReposListViewModel(reposUseCase: searchReposUseCaseMock)
        // when
        viewModel.viewDidLoad()
        waitForExpectations(timeout: 5, handler: nil)
        
        searchReposUseCaseMock.expectation = self.expectation(description: "Second page loaded")
        searchReposUseCaseMock.page = ReposPage(totalCount: 1, incompleteResults: false, repos:  reposPages[0].repos)
        viewModel.didLoadNextPage()
        
        // then
//        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertFalse(viewModel.hasMorePages)
    }
}
