//
//  UpcomingTableViewCell.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    static let identifier = "UpcomingTableViewCell"
    
    private var titleImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var titlelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [titleImage, titlelabel].forEach(contentView.addSubview)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints(){
        NSLayoutConstraint.activate([
            titleImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleImage.widthAnchor.constraint(equalToConstant: 90),
            
            titlelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlelabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 10),
            titlelabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with model: TitleModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.imageString)") else {return}
        titleImage.sd_setImage(with: url)
        titlelabel.text = model.title
    }
}
