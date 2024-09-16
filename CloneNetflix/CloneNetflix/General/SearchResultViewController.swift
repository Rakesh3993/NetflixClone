//
//  SearchResultViewController.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultCollectionViewCellDidTapItem(_ viewModel: YoutubeModel)
}

class SearchResultViewController: UIViewController {
    
    public var titleArray: [Title] = [Title]()
    
    public var delegate: SearchResultViewControllerDelegate?
    
    public var searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 150)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
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
                self.delegate?.searchResultCollectionViewCellDidTapItem(viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
