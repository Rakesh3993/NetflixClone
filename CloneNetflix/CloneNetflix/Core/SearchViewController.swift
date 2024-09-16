//
//  SearchViewController.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit

class SearchViewController: UIViewController {
    var titleArray: [Title] = [Title]()
    
    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "search movies"
        return controller
    }()
    
    private var searchTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        fetchData()
        constraints()
    }
    
    private func constraints(){
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchData(){
        APICaller.shared.fetchData { result in
            switch result {
            case .success(let title):
                self.titleArray = title
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        let title = titleArray[indexPath.row]
        cell.configure(with: TitleModel(imageString: title.poster_path, title: title.original_title))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titleArray[indexPath.row]
        
        let titleName = title.original_title
        
        APICaller.shared.getMovies(query: titleName + " trailer") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async{[weak self] in
                    let vc = ResultViewController()
                    vc.configure(with: YoutubeModel(title: title.original_title, overview: title.overview, youtubeLink: data.id.videoId))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else {return}
        
        resultController.delegate = self
        
        APICaller.shared.search(query: query) { result in
            switch result {
            case .success(let title):
                resultController.titleArray = title
                DispatchQueue.main.async {
                    resultController.searchResultCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchViewController: SearchResultViewControllerDelegate {
    func searchResultCollectionViewCellDidTapItem(_ viewModel: YoutubeModel) {
        DispatchQueue.main.async {[weak self] in
            let vc = ResultViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

