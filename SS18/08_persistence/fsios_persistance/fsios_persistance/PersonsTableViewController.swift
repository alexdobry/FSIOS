//
//  PersonsTableViewController.swift
//  fsios_persistance
//
//  Created by Alex on 01.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CoreData
// NSSortDescriptor(keyPath: \Person.gender, ascending: true),

class PersonsTableViewController: UITableViewController {
    
    var viewContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Person> = {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Person.name, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        
        return controller
    }()
    
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        i = (try? viewContext.count(for: fetchRequest)) ?? 0*/
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createPerson))
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "FSK 18", style: .plain, target: self, action: #selector(fsk(_:))),
            UIBarButtonItem(title: "Lift Ages by 1", style: .plain, target: self, action: #selector(liftAges))
        ]
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(#function, error.localizedDescription)
        }
    }
    
    private func fetchAll() {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest() // need to typed explicitly
        _ = try? viewContext.fetch(fetchRequest) // perform the fetch (select all)
    }
    
    private func fetchSpecific() {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest() // need to typed explicitly

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true), // oder by name first
            NSSortDescriptor(keyPath: \Person.age, ascending: false) // and by age second
        ]
        
        let atLeast18YearsOld = NSPredicate(format: "age >= %ld", 18) // filter
        let livingInSteinmuellerallee = NSPredicate(format: "address.street == %@", "Steinmüllerallee") // join and filter
        
        let searchString = ""
        let searchPredicate = NSPredicate(format: "%K contains %@", #keyPath(Person.name), searchString) // variable filtering
        print(searchPredicate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ // also `or` and `not`
            atLeast18YearsOld, livingInSteinmuellerallee
            ])
        
        let persons = try? viewContext.fetch(fetchRequest) // perform the fetch
        persons?.forEach { person in
            print(person) // no content will be printed here because objects are unfaulted
            print(person.name!, person.address!) // now we are faulting
        }
    }
    
    private func fetchCount() {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest() // need to typed explicitly
        let count = try? viewContext.count(for: fetchRequest) // count the number of objects which are effected by the given fetch request
        
        print(count ?? 0) // 10 e.g.
    }
    
    private func delete(_ person: Person) {
        viewContext.delete(person)
    }
    
    @objc func createPerson() { // insert into db
        let person = Person(context: viewContext) // use this init function provided by NSManagedObject for property based storage
        person.name = "Person \(i)"
        person.age = Int16(i)
        person.gender = (i % 2 == 0 ? Gender.male : Gender.female).rawValue
        
        let address = Address(context: viewContext) // same here
        address.street = "Street \(i)"
        address.city = "City \(i)"
        person.address = address // this will create our 1:m relationship
        // address.addToPersons(person) // regardless which one to use
        
        // try? viewContext.save() // persist changes. in memory only otherwise
        
        i += 1
    }
    
    @objc func fsk(_ button: UIBarButtonItem) {
        if button.title!.contains("on") {
            button.title = "FSK 18 off"
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            button.title = "FSK 18 on"
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K >= %ld", #keyPath(Person.age), 18)
        }
        
        
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    @objc func liftAges() { // update each entity in db
        fetchedResultsController.fetchedObjects?.forEach { $0.age += 1 }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonsCell", for: indexPath)
        let person = fetchedResultsController.object(at: indexPath)
        let address = person.address!
        
        cell.textLabel?.text = "\(person.name!), \(person.age), \(person.gender!)"
        cell.detailTextLabel?.text = "\(address.street!), \(address.city!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    // MARK: - Table view data delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let person = fetchedResultsController.object(at: indexPath)
            viewContext.delete(person)
            
        case .insert, .none: break
        }
    }
}

extension PersonsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
