//
//  TrendTableViewCell.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//

import UIKit
import Kingfisher
import SVGKit
import SkeletonView

class TrendTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: TrendTableViewCell.self)
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet weak var starSVGImageView: SVGKImageView!
    
    @IBOutlet weak var languageImageView: UIImageView!
    
    @IBOutlet weak var bottomView: UIStackView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        nameLabel.textColor = UIColor(named: "primaryTextColor")
        repoDescriptionLabel.textColor = UIColor(named: "primaryTextColor")
        languageLabel.textColor = UIColor(named: "primaryTextColor")
        rateLabel.textColor = UIColor(named: "primaryTextColor")
        repoNameLabel.textColor = UIColor(named: "forground")
        
        nameLabel.font = repoNameLabel.font.withSize(17)
        repoDescriptionLabel.font = repoNameLabel.font.withSize(17)
        languageLabel.font = repoNameLabel.font.withSize(17)
        rateLabel.font = repoNameLabel.font.withSize(17)
        repoNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        repoDescriptionLabel.numberOfLines = 0
        repoDescriptionLabel.lineBreakMode = .byWordWrapping
    }
    
    
    func fill(with viewModel: ReposListItemViewModel )  {
        rateLabel.text = "\(viewModel.stargazersCount ?? 0)"
        if let language = viewModel.language {
            languageLabel.text = language
            languageImageView.isHidden = false
        }
        nameLabel.text = viewModel.name
        repoDescriptionLabel.text = viewModel.description
        repoNameLabel.text = viewModel.ownerLogin
        profileImageView.kf.setImage(with: URL(string:viewModel.ownerImageUrl )) { result in
            switch result {
            case .success(_):
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
                self.profileImageView.clipsToBounds = true
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        bottomView.isHidden = !viewModel.isExpanded
        
    }
    
}
