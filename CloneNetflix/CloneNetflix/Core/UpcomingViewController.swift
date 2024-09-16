//
//  UpcomingViewController.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    var titleArray: [Title] = [Title]()
    
    private var upcomingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(upcomingTableView)
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        fetchData()
        constraints()
    }
    
    private func constraints(){
        NSLayoutConstraint.activate([
            upcomingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            upcomingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upcomingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upcomingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
