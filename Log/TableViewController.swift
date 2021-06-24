//
//  ViewController.swift
//  Log
//
//  Created by Taras Shukhman on 24/06/2021.
//



import UIKit
import CoreData


class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Movies.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "releaseYear", ascending: ascending)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Database.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var ascending = false


    

        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Movies"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🔎", style: .plain, target: self, action: #selector(openQRScaner))
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "↕️", style: .plain, target: self, action: #selector(filter))
    
            clearData()
            tableView.register(MovieCell.self, forCellReuseIdentifier: "Cell")
            updateTableContent()
        }
        
    
    
        
    @objc func openQRScaner(){
        let scaner = QRScannerVC()
        present(scaner, animated: true)
    }
    @objc func filter(){
        if ascending == false {
            ascending = true
        } else {
            ascending = false
        }
        updateTableContent()
        
    }
        
        
    func updateTableContent(){
            do {
                try self.fetchedResultController.performFetch()
            } catch let error  {
                print("ERROR: \(error)")
            }
            let service = Networking()
            service.getDataWithStaticJSONurl{ (result) in
                switch result {
                case .Success(let data):
                    self.clearData()
                    self.saveInCoreDataWith(array: data)
                case .Error(let message):
                    DispatchQueue.main.async {
                        self.showAlertWith(title: "Error", message: message)
                    }
                }
            }
        }
        
        private func clearData() {
            do {
                let context = Database.shared.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
                do {
                    let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                    _ = objects.map{$0.map{context.delete($0)}}
                    Database.shared.saveContext()
                } catch let error {
                    print("error : \(error)")
                }
            }
        }
        
        
        
        func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            let action = UIAlertAction(title: title, style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        
        private func createMovieEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
            let context = Database.shared.persistentContainer.viewContext
            if let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "Movies", into: context) as? Movies {
                movieEntity.title = dictionary["title"] as! String
                movieEntity.image = dictionary["image"] as! String
                movieEntity.releaseYear = dictionary["releaseYear"] as! Int16
                movieEntity.rating = Float(truncating: dictionary["rating"] as! NSNumber)
                movieEntity.genre = dictionary["genre"] as! [String]
                return movieEntity
            }
            return nil
        }
        
        private func saveInCoreDataWith(array: [[String: AnyObject]]) {
            _ = array.map{self.createMovieEntityFrom(dictionary: $0)}
            do {
                try Database.shared.persistentContainer.viewContext.save()
            } catch  {
                print("error")
            }
        }
        
    }


    //MARK: - NSFetchedResults delegate Extension
    extension TableViewController {
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

            switch type {
            case .insert:
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            case .delete:
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            default:
                break
            }
        }
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.tableView.endUpdates()
        }
        
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
        }
        

    }


    //MARK: - TableView delegate Extension
    extension TableViewController {
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieCell
            if let movie = fetchedResultController.object(at: indexPath) as? Movies {
                cell.movie = movie
                }
                cell.backgroundColor = cellMovieColor
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let count = fetchedResultController.sections?.first?.numberOfObjects {
                return count
            }
            return 0
        }
        

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let dv = DetailVC()
            if let movie = fetchedResultController.object(at: indexPath) as? Movies {
                dv.movie = movie
                }
            navigationController?.pushViewController(dv, animated: true)
        }
        
        
        
        
    }

