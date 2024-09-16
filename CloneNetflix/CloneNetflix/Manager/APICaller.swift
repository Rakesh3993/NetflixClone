//
//  APICaller.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 14/09/24.
//

import Foundation

struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDcBewstL2DjEEG2ucS4mV2XMnk1kNc8ns"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

class APICaller {
    static let shared = APICaller()
    
    func fetchData(completion: @escaping (Result<[Title], Error>)->()){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let safeData = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do{
                let result = try JSONDecoder().decode(TitleResponse.self, from: safeData)
                completion(.success(result.results))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getMovies(query: String, completion: @escaping (Result<VideoElement, Error>)->()){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let safeData = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do{
                let result = try JSONDecoder().decode(YouTubeResponse.self, from: safeData)
                print(result.items[0])
                completion(.success(result.items[0]))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func search(query: String, completion: @escaping (Result<[Title], Error>)->()){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let safeData = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do{
                let result = try JSONDecoder().decode(TitleResponse.self, from: safeData)
                completion(.success(result.results))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
