//
//  FirstTypeTableViewController.swift
//  Keeper
//
//  Created by admin on 4/26/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData

class FirstTypeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var type: Types!
    var types: [Types] = []
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Reloader()
        
        tableView.separatorColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.2)
        tableView.backgroundColor = UIColor.clear
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Types")
        
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
                fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
                types = fetchedResultsController.fetchedObjects as! [Types]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Reloader()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Types")
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
                types = fetchedResultsController.fetchedObjects as! [Types]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return types.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TypesTableViewCell
        
        cell.typesLabel.text = types[indexPath.row].type
        cell.backgroundColor = UIColor.clear
        cell.typesLabel.textColor = UIColor(red: 158, green: 69, blue: 69, alpha: 1)
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                let rowsToDelete = self.fetchedResultsController.object(at: indexPath) as! Types
                managedObject.delete(rowsToDelete)
                
                self.types.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                do {
                    try managedObject.save()
                } catch {
                    print("error")
                }
                
                self.forVC()
                
            }
        }
        
    }
    
    func Reloader() {
        tableView.reloadData()
        print("Relaoded")
    }
    
    func forVC() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Types")
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
                types = fetchedResultsController.fetchedObjects as! [Types]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        Reloader()
}
}
