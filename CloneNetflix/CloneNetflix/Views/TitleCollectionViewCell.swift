//
//  TitleCollectionViewCell.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit
import Foundation

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    private var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleImageView)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints(){
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with model: TitleModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.imageString)") else {return}
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let uiimage = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                self.titleImageView.image = uiimage
            }
        }.resume()
    }
}
