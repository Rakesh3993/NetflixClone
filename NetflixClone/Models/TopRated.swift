//
//  TopRated.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 23/04/24.
//

import Foundation

struct TopratedMoviesResponse: Codable {
    let results: [TopRated]
}

struct TopRated: Codable {
    let adult: Bool
    let backdrop_path: String
    let genre_ids: [Int]
    let id: Int
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let release_date: String?
    let title: String?
    let vote_average: Double
    let vote_count: Int
}
