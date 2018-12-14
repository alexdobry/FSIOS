//
//  TagsTableViewController.swift
//  Yatodoa
//
//  Created by Alex on 04.12.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CoreData

class TagsTableViewController: NSFetchedResultsTableViewController {
    
    // MARK: public api
    var todo: Todo?
    
    var viewContext: NSManagedObjectContext = AppDelegate.viewContext
    
    lazy var fetchedResultsController: NSFetchedResultsController<Tag> = {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.sortDescriptors = []
        
        let controller = NSFetchedResultsController<Tag>(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Taggen"
        
        try? fetchedResultsController.performFetch()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCellReuseIdentifier", for: indexPath)
        let tag = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = tag.title
        cell.textLabel?.textColor = tag.color

        if todo!.joinedTags.contains(tag) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedTag = fetchedResultsController.object(at: indexPath)

        if todo!.joinedTags.contains(selectedTag) {
            todo!.removeFromTags(selectedTag)
        } else {
            todo!.addToTags(selectedTag)
        }
    }
}
