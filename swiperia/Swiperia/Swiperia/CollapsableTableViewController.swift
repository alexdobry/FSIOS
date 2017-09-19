//
//  CollapsableTableViewController.swift
//  Swiperia
//
//  Created by Edgar Gellert on 14.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit

class CollapsableTableViewController: UITableViewController {
    
    let data = [
        CollapseableViewModel(label: "Account", image: nil, children: [
            CollapseableViewModel(label: "Profile"),
            CollapseableViewModel(label: "Activate Account"),
            CollapseableViewModel(label: "Change Password")]),
        CollapseableViewModel(label: "Group"),
        CollapseableViewModel(label: "Events", image: nil, children: [
            CollapseableViewModel(label: "Nearby"),
            CollapseableViewModel(label: "Global"),
            ]),
        CollapseableViewModel(label: "Deals")
    ]
    
    var displayedRows : [CollapseableViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        displayedRows = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedRows.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "MultiPlayerCell", for: indexPath) as? CollapsableTableViewCell) ?? CollapsableTableViewCell(style: .default, reuseIdentifier: "MultiPlayerCell")
        let viewModel = displayedRows[indexPath.row]
        cell.textLabel?.text = viewModel.label
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let viewModel = displayedRows[indexPath.row]
        
        if viewModel.children.count > 0 {
            let range = indexPath.row+1...indexPath.row+viewModel.children.count
            let indexPaths = range.map{return NSIndexPath(row: $0, section: indexPath.section)}
            tableView.beginUpdates()
            
            if viewModel.isCollapsed {
                displayedRows.insert(contentsOf: viewModel.children, at: indexPath.row+1)
                tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
            } else {
                displayedRows.removeSubrange(range)
                tableView.deleteRows(at: indexPaths as [IndexPath], with: .automatic)
            }
            tableView.endUpdates()
        }
        viewModel.isCollapsed = !viewModel.isCollapsed
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
