//
//  ViewController.swift
//  JSONtoCoreData
//
//  Created by anoopm on 23/12/17.
//  Copyright © 2017 anoopm. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // Add data again
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        self.store.fetchAllAlbums { (data, error) in
            
        }
    }
    
    let store = AlbumDataStore.shared()
    @IBOutlet weak var albumTableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        store.fetchedResultController.delegate = self
        store.fetchAllAlbums { (data, error) in
            DispatchQueue.main.async {
                self.store.showData()
                self.albumTableView.reloadData()      
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return store.sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return store.rowsCountIn(section: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath)
        if let item = store.itemAt(indexPath: indexPath) {
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.artist
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return store.titleForHeaderAt(section: section)
    }

}
extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        albumTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        albumTableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                albumTableView.insertRows(at: [indexPath], with: .middle)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                albumTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            break;
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            albumTableView.insertSections(IndexSet(integer: sectionIndex), with: .middle)
        case .delete:
            albumTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break;
        }
    }
    
}
