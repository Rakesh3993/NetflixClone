//
//  YouTubeResponse.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import Foundation

struct YouTubeResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}

