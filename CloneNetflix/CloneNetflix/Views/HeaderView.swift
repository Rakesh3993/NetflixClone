//
//  HeaderView.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit

protocol HeaderViewCollectionViewDelegate: AnyObject {
    func headerCollectionViewItemDidTap(viewModel: YoutubeModel)
}

class HeaderView: UIView {
    
    var titleArray: [Title] = [Title]()
    var timer: Timer?
    var currentItem: Int = 0
    weak var delegate: HeaderViewCollectionViewDelegate?
    
    var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 50, height: 450)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(HeaderCollectionView.self, forCellWithReuseIdentifier: HeaderCollectionView.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [headerCollectionView].forEach(addSubview)
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        contraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func contraints(){
        NSLayoutConstraint.activate([
            headerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerCollectionView.topAnchor.constraint(equalTo: topAnchor),
            headerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func autoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }
    
    @objc func startTimer(){
        guard !titleArray.isEmpty else {return}
        let totalItem = titleArray.count
        let indexPath = IndexPath(item: currentItem, section: 0)
        headerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentItem += 1
        if currentItem >= totalItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.headerCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                self.currentItem = 0
            }
        }
    }
}

extension HeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionView.identifier, for: indexPath) as? HeaderCollectionView else {
            return UICollectionViewCell()
        }
        let data = titleArray[indexPath.row]
        cell.configure(with: data.poster_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = titleArray[indexPath.row]
        let titleQuery = title.original_title
        
        APICaller.shared.getMovies(query: titleQuery+"trailer") { result in
            switch result {
            case .success(let data):
                let youtubeModel = YoutubeModel(title: title.original_title, overview: title.overview, youtubeLink: data.id.videoId)
                self.delegate?.headerCollectionViewItemDidTap(viewModel: youtubeModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}
