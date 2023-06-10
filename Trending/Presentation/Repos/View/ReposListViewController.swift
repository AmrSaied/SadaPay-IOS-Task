//
//  ViewController.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//

import UIKit
import Lottie
import SkeletonView
class ReposListViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet weak var trendTableView: UITableView!
    @IBOutlet weak var loadingErrorView: UIView!
    @IBOutlet weak var animationView: LottieAnimationView!
    var viewModel: ReposListViewModel!
    
    var expandedIndexSet : IndexSet = []
    
    static func create(with viewModel: ReposListViewModel) -> ReposListViewController {
        let view = ReposListViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Show Shimmer
        trendTableView.isSkeletonable = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func setupViews(){
        trendTableView.register(UINib(nibName: "TrendTableViewCell", bundle: nil), forCellReuseIdentifier: TrendTableViewCell.reuseIdentifier)
        trendTableView.rowHeight = UITableView.automaticDimension
        trendTableView.estimatedRowHeight = 80
        
    }
    
    private func bind(to viewModel: ReposListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    private func showError(_ error: String) {
        if error != "" {
            self.loadingError()
        }
        //        guard !error.isEmpty else { return }
        //        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    private func updateItems() {
        trendTableView.reloadData()
    }
    
    private func updateLoading(_ loading: ReposListViewModelLoading?) {
        
        switch loading {
        case .firstPage:
            trendTableView.showAnimatedSkeleton()
            
        case .nextPage: do {
            
        }
        case .none:
            //trendTableView.isHidden = viewModel.isEmpty
            // Hide Shimmer
            self.trendTableView.stopSkeletonAnimation()
            self.view.hideSkeleton()
            self.trendTableView.reloadData()
        }
    }
    
    func loadingError() {
        loadingErrorView.isHidden = false
        trendTableView.isHidden = true
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        animationView!.play()
    }
    
    @IBAction func retryAction(_ sender: Any) {
        loadingErrorView.isHidden = true
        trendTableView.isHidden = false
        viewModel.viewDidLoad()
    }
    
}

