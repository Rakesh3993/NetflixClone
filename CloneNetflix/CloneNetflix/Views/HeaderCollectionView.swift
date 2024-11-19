//
//  HeaderCollectionView.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 19/11/24.
//

import UIKit

class HeaderCollectionView: UICollectionViewCell {
    
    static let identifier = "HeaderCollectionView"
    
    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [posterImageView, downloadButton, playButton].forEach(addSubview)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            downloadButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configure(with image: String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(image)") else {return}
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let uiimage = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.posterImageView.image = uiimage
            }
        }.resume()
    }
}
