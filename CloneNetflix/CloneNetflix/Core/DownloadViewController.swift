//
//  DownloadViewController.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit

class DownloadViewController: UIViewController {
    
    var titleArray: [TitleItem] = [TitleItem]()
    
    private var downloadTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(downloadTableView)
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        fetchDataToDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchDataToDownload()
        }
        constraints()
    }
    
    private func constraints(){
        NSLayoutConstraint.activate([
            downloadTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            downloadTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            downloadTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            downloadTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchDataToDownload(){
        DataPersistenceManager.shared.fetchData {[weak self] result in
            switch result {
            case .success(let data):
                self?.titleArray = data
                self?.downloadTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        let title = titleArray[indexPath.row]
        cell.configure(with: TitleModel(imageString: title.poster_path ?? "", title: title.original_title ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteData(with: titleArray[indexPath.row]) { result in
                switch result {
                case .success():
                    print("data deleted")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.titleArray.remove(at: indexPath.row)
                self.downloadTableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titleArray[indexPath.row]
        let titleName = title.original_title ?? title.original_name ?? ""
        APICaller.shared.getMovies(query: titleName + " trailer") {[weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.sync {
                    let vc = ResultViewController()
                    vc.configure(with: YoutubeModel(title: title.original_title ?? "", overview: title.overview ?? "", youtubeLink: data.id.videoId))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
