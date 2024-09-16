//
//  DataPersistenceManager.swift
//  CloneNetflix
//
//  Created by Rakesh Kumar on 15/09/24.
//

import Foundation
import UIKit
import CoreData

enum HandleAppErr: Error {
    case downloadError
    case fetchError
    case deleteError
}

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func downloadData(with model: Title, completion: @escaping (Result<(), Error>)->()){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let items = TitleItem(context: context)
        
        items.id = Int64(model.id)
        items.media_type = model.media_type
        items.original_name = model.title
        items.original_title = model.original_title
        items.overview = model.overview
        items.poster_path = model.poster_path
        items.release_date = model.release_date
        items.vote_average = model.vote_average
        items.vote_count = Int64(model.vote_count)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            print(error)
            completion(.failure(HandleAppErr.downloadError))
        }
    }
    
    
    func fetchData(completion: @escaping (Result<[TitleItem], Error>)->()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do{
            let data = try context.fetch(request)
            completion(.success(data))
        }catch{
            print(error)
            completion(.failure(HandleAppErr.fetchError))
        }
    }
    
    func deleteData(with model: TitleItem, completion: @escaping (Result<(), Error>) -> ()){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            print(error)
            completion(.failure(HandleAppErr.deleteError))
        }
        
    }
}
