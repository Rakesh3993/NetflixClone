//
//  Title.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import Foundation

struct TitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id : Int
    let original_title: String
    let overview: String
    let poster_path: String
    let title: String
    let release_date: String
    let vote_count: Int
    let vote_average: Double
    let media_type: String
}
