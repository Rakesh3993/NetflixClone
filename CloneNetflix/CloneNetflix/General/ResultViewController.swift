//
//  ResultViewController.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import UIKit
import WebKit

class ResultViewController: UIViewController {
    
    private var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
        label.textColor = .label
        return label
    }()
    
    private var downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .red
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        [webView, titleLabel, overviewLabel, downloadButton].forEach(view.addSubview)
        constraints()
    }
    
    private func constraints(){
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 20),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configure(with model: YoutubeModel){
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeLink)") else {return}
        webView.load(URLRequest(url: url))
    }
}
