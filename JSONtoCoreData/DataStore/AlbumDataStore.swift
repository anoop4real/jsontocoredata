//
//  AlbumDataStore.swift
//  JSONtoCoreData
//
//  Created by anoopm on 23/12/17.
//  Copyright © 2017 anoopm. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AlbumDataStore{
    
    let networkManager = NetworkDataManager.sharedNetworkmanager
    lazy var coreDataManager = CoreDataManager.sharedInstance
    
    private static let _shared = AlbumDataStore()
    private init(){
        let _ = coreDataManager.managedObjectContext
    }
    class func shared()-> AlbumDataStore{
                
        return _shared
    }
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Album.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataManager.managedObjectContext, sectionNameKeyPath: #keyPath(Album.title), cacheName: nil)
        return frc
    }()
    func fetchAllAlbums(completion:@escaping (_ data: Any?,_ error: Error?)->Void)->Void{
        let url = createURL()
        let request = URLRequest(url: url)
        networkManager.fetchDataWithUrlRequest(request) {[weak self] (success, data) in
            if success{
                print(data!)
                let jsonDecoder = JSONDecoder()
                do {
                    let responseModel = try jsonDecoder.decode([Albums].self, from: data!)

                    self?.saveDataWith(reponse: responseModel)
                    completion(responseModel, nil)
                } catch let error {
                    print(error.localizedDescription)

                }
            }else{
                
            }
        }
    }
    
    func showData(){
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    private func createURL() -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.APIDetails.APIScheme
        components.host   = Constants.APIDetails.APIHost
        components.path   = Constants.APIDetails.APIPath
        
        return components.url!
    }
    
    private func createAlbumEntityFrom(responseModel: Albums) -> NSManagedObject?{
        // TODO: Do a guard check
        // iOS 10 and above
        let album = Album(context: coreDataManager.managedObjectContext)
        album.artist = responseModel.artist
        album.image  = responseModel.image
        album.title  = responseModel.title
        album.thumbnailImage = responseModel.thumbnail_image
        album.url = responseModel.url
        
        return album
    }
    
    private func saveDataWith(reponse: [Albums]){
        
        _ = reponse.map{self.createAlbumEntityFrom(responseModel: $0)}
        
        coreDataManager.saveContext()
        
    }
}

extension AlbumDataStore:DataStoreProtocol{
    func sectionCount() -> Int {
        guard let sections = fetchedResultController.sections else { return 0 }
        return sections.count
    }
    
    func rowsCountIn(section: Int) -> Int {
        guard let sectionInfo = fetchedResultController.sections?[section] else { fatalError("Unexpected Section") }
        return sectionInfo.numberOfObjects
    }
    func itemAt(indexPath: IndexPath) -> Album?{
        if let album = fetchedResultController.object(at: indexPath) as? Album{
            return album
        }
        return nil
    }
    func titleForHeaderAt(section: Int) -> String{
        
        guard let sectionInfo = fetchedResultController.sections?[section] else { return "" }
        return sectionInfo.name
    }
    
}
