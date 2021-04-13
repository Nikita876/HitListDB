//
//  TableViewController.swift
//  HitList
//
//  Created by Никита Коголенок on 18.02.21.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    // MARK: - Variabels
    var people: [NSManagedObject] = []
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = saveContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            people = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let context = saveContext()
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
//        if let results = try? context.fetch(fetchRequest) {
//            for result in results {
//                context.delete(result)
//            }
//        }
//
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
    // MARK: - Action
    @IBAction func saveName(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alertController.textFields?.first
            if let nameToSave = textField?.text {
                self.save(name: nameToSave)
                self.tableView.reloadData()
            }
        }
        alertController.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - SaveContext
    private func saveContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    // MARK: - Methods
    private func save(name: String) {
        let context = saveContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }
        
        let person = NSManagedObject(entity: entity, insertInto: context)
        person.setValue(name, forKey: "name")
        
        do {
            try context.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
}
