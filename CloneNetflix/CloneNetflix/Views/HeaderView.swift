//
//  HeaderView.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit

class HeaderView: UIView {
    
    var titleArray: [Title] = [Title]()
    
    private var posterImageView: UIImageView = {
       let image = UIImageView()
        return image
    }()
    
    private var downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private var playButton: UIButton = {
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
        contraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = bounds
    }
    
    private func contraints(){
        NSLayoutConstraint.activate([
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
    
    func configure(with model: TitleModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.imageString)") else {return}
        posterImageView.sd_setImage(with: url)
    }
}
