//
//  TableReposListViewController.swift
//  Trending
//
//  Created by Amr Saied on 04/03/2023.
//

import Foundation
import UIKit
import SkeletonView

extension ReposListViewController : UITableViewDelegate , SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count;
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TrendTableViewCell.reuseIdentifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? TrendTableViewCell else {
            assertionFailure("Cannot dequeue reusable cell \(TrendTableViewCell.self) with reuseIdentifier: \(TrendTableViewCell.reuseIdentifier)")
            return UITableViewCell()
        }
        cell.fill( with: self.viewModel.items.value[indexPath.row])
        if expandedIndexSet.contains(indexPath.row) {
            cell.bottomView.isHidden = false
        } else {
            cell.bottomView.isHidden = true
        }
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
        } else {
            expandedIndexSet.insert(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       let lastSectionIndex = tableView.numberOfSections - 1
       let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
       if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
          // print("this is the last cell")
           let spinner = UIActivityIndicatorView(style: .gray)
           spinner.startAnimating()
           spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

           self.trendTableView.tableFooterView = spinner
           self.trendTableView.tableFooterView?.isHidden = false
       }
   }

}
