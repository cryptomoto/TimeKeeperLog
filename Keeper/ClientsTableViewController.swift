//
//  ClientsTableViewController.swift
//  Keeper
//
//  Created by admin on 5/15/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData

class ClientsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var clients: [Clients] = []
   // var filteredClients = [Clients]()
    ///var client: Clients!
    
    
    var delegate: ClientsViewController?
    
    //let searchController = UISearchController(searchResultsController: nil)
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //searchController.searchResultsUpdater = self
       // searchController.dimsBackgroundDuringPresentation = false
        //definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
        
        tableView.allowsSelection = true
        
        tableView.separatorColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        //let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ClientsTableViewController.addClient))
       // self.navigationItem.rightBarButtonItem = add
        
        self.fetchData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                
                let rowsToDelete = self.fetchedResultsController.object(at: indexPath) as! Clients
                managedObject.delete(rowsToDelete)
                
                self.clients.remove(at: indexPath.row)
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
    
    /*func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredClients = clients.filter { client in
            return client.name!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }*/

   /* func addClient() {
        
        self.delegate?.viewAppears()
        
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        self.forVC()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.forVC()
    }
    
    func forVC() {
        self.fetchData()
        //self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClientCell
        
        cell.backgroundColor = UIColor.clear
        cell.selectedBackgroundView?.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        if clients[indexPath.row].company != nil && clients[indexPath.row].company != "" {
            
            cell.clientName.text = "\(clients[indexPath.row].name!) from \(clients[indexPath.row].company!)"
            
        } else {
            
            cell.clientName.text = clients[indexPath.row].name!
        }
        
        if clients[indexPath.row].email == nil && clients[indexPath.row].phone == nil {
            cell.clientEmail.text = "No phone and no e-mail"
        } else if clients[indexPath.row].email != nil && clients[indexPath.row].phone == nil {
            cell.clientEmail.text = clients[indexPath.row].email!
        } else if clients[indexPath.row].phone != nil && clients[indexPath.row].email == nil {
            cell.clientEmail.text = clients[indexPath.row].phone!
        } else if clients[indexPath.row].email != nil && clients[indexPath.row].phone != nil {
            cell.clientEmail.text = "\(clients[indexPath.row].email!) / \(clients[indexPath.row].phone!))"
        }
        
        /*if searchController.active && searchController.searchBar.text != "" {
            client = filteredClients[indexPath.row]
        } else {
            client = clients[indexPath.row]
        }
        
        if client.company != nil && client.company != "" {
            
            cell.clientName.text = "\(client.name!) from \(client.company!)"
            
        } else {
            
            cell.clientName.text = client.name!
        }
        
        cell.clientEmail.text = client.email!*/


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Choose action", message: nil, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: "Information", style: .default, handler: ({ (ACTION) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let contactVC = storyboard.instantiateViewController(withIdentifier: "contactVC") as! ContactViewController
            contactVC.clients = self.clients[indexPath.row]
            self.present(contactVC, animated: true, completion: nil)
            
        }))
        
        let secondAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        self.present(alert, animated: true, completion: nil)
        
    }
   
    
    func fetchData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Clients")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
                fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
                clients = fetchedResultsController.fetchedObjects as! [Clients]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        tableView.reloadData()
    }
    
}
