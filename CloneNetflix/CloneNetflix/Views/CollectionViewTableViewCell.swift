//
//  CollectionViewTableViewCell.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTapItem(_ cell: CollectionViewTableViewCell, viewModel: YoutubeModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"
    weak var delegate: CollectionViewTableViewCellDelegate?
    var titleArray: [Title] = [Title]()
    
    private var titleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleCollectionView)
        titleCollectionView.delegate = self
        titleCollectionView.dataSource = self
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints(){
        NSLayoutConstraint.activate([
            titleCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with title: [Title]){
        titleArray = title
        DispatchQueue.main.async{
            self.titleCollectionView.reloadData()
        }
    }
    
    private func downloadRowAt(indexPath: IndexPath){
        DataPersistenceManager.shared.downloadData(with: titleArray[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let title = titleArray[indexPath.row]
        cell.configure(with: TitleModel(imageString: title.poster_path, title: title.original_title))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titleArray[indexPath.row]
        let titleName = title.original_title
        
        APICaller.shared.getMovies(query: titleName + " trailer") { result in
            switch result {
            case .success(let data):
                let viewModel = YoutubeModel(title: title.original_title, overview: title.overview, youtubeLink: data.id.videoId)
                self.delegate?.CollectionViewTableViewCellDidTapItem(self, viewModel: viewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                let downloadAction = UIAction(
                    title: "Download",
                    image: nil,
                    identifier: nil,
                    discoverabilityTitle: nil,
                    state: .off) { _ in
                        self.downloadRowAt(indexPath: indexPath)
                    }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
}
