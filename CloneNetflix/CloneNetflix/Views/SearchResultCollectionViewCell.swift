//
//  SearchResultCollectionViewCell.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultCollectionViewCell"
    
    private var posterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        posterImage.frame = contentView.bounds
    }
    
    func configure(with model: TitleModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.imageString)") else {return}
        posterImage.sd_setImage(with: url)
    }
}
