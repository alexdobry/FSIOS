//
//  NearbyBrowserTableViewController.swift
//  Switcheroo
//
//  Created by Dennis Dubbert on 17.05.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class NearbyBrowserTableViewController: UITableViewController {
    
    // MARK: Properties
    
    fileprivate var peers : [MCPeerID] = []
    
    private let colorManager = ColorServiceManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        colorManager.browserDelegate = self
        colorManager.startBrowse()
        self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyBrowserTableViewCell", for: indexPath) as? NearbyBrowserTableViewCell else {fatalError("table row geht nicht")}
        
        let peerName = peers[indexPath.row].displayName
        
        print("hallo cell" + peerName)
        
        cell.name.text = peerName

        // Configure the cell...

        return cell
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

extension NearbyBrowserTableViewController : ColorServiceManagerBrowserDelegate {
    func found(device: MCPeerID) {
        self.peers.append(device)
        print(peers)
        self.tableView.reloadData()
    }
    
    func lost(device: MCPeerID) {
        self.peers = self.peers.filter({$0.description != device.description})
        print(peers)
        self.tableView.reloadData()
    }
}


