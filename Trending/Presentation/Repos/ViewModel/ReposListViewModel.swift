//
//  ReposListViewModel.swift
//  Trending
//
//  Created Amr Saied
//

import Foundation

struct ReposListViewModelActions {
    let showRepoDetails: (Repo) -> Void

}

enum ReposListViewModelLoading {
    case firstPage
    case nextPage
}

protocol ReposListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSelectItem(at index: Int)
}

protocol ReposListViewModelOutput {
    var items: Observable<[ReposListItemViewModel]> { get }
    var loading: Observable<ReposListViewModelLoading?> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol ReposListViewModel: ReposListViewModelInput, ReposListViewModelOutput {}

final class DefaultReposListViewModel: ReposListViewModel {

    private let reposUseCase: ReposUseCase
    private let actions: ReposListViewModelActions?

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPageNumber: Int { hasMorePages ? currentPage + 1 : currentPage }

    private var pages: [ReposPage] = []
    private var reposLoadTask: Cancellable? { willSet { reposLoadTask?.cancel() } }

    // MARK: - OUTPUT

    let items: Observable<[ReposListItemViewModel]> = Observable([])
    let loading: Observable<ReposListViewModelLoading?> = Observable(.none)
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Repos", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Repos", comment: "")

    // MARK: - Init

    init(reposUseCase: ReposUseCase,
         actions: ReposListViewModelActions? = nil) {
        self.reposUseCase = reposUseCase
        self.actions = actions
    }

    // MARK: - Private

    private func appendPage(_ reposPage: ReposPage) {
        currentPage = currentPage + 1 ;
        totalPageCount = reposPage.totalCount
        pages = pages
            .filter { $0.totalCount != reposPage.totalCount }
            + [reposPage]

        items.value = pages.repos.map(ReposListItemViewModel.init)
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }

    private func load(repoQuery: RepoQuery, loading: ReposListViewModelLoading) {
        self.loading.value = loading
        reposLoadTask = reposUseCase.execute(
            requestValue: .init(query: repoQuery, page: nextPageNumber),
            cached: appendPage,
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                self.loading.value = .none
        })
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading repos", comment: "")
    }

    private func update(repoQuery: RepoQuery) {
        resetPages()
        load(repoQuery: repoQuery, loading: .firstPage)
    }
}

// MARK: - INPUT. View event methods
extension DefaultReposListViewModel {

    func viewDidLoad() {
        load(repoQuery: RepoQuery(q: "Q", sort: "asc"), loading: ReposListViewModelLoading.firstPage)
    }

    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(repoQuery: .init(q: "Q", sort: "asc"),
             loading: .nextPage)
    }





    func didSelectItem(at index: Int) {
        actions?.showRepoDetails(pages.repos[index])
    }
}

// MARK: - Private

private extension Array where Element == ReposPage {
    var repos: [Repo] { flatMap { $0.repos } }
}
