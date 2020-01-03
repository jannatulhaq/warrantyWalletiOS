//
//  ItemsTableViewController.swift
//  Warranty Wallet
//
//  Created by Zaeni Hoque on 12/15/19.
//  Copyright © 2019 Zaeni Hoque. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var itemNameNew: String = ""
    var itemCategoryNew: String = ""
    var amountNew: String = ""
    var warrantyNew: String = ""
    var dateNew: String = ""
    var sellerNameNew: String = ""
    var sellerPhoneNew: String = ""
    var sellerEmailNew: String = ""
    var imageNew: UIImage!

    //already existing items (example)
    var items = [(itemName: "s7", category: "Mobiles"),
             (itemName: "coffee maker", category: "Kitchen Products")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // go to add item function
        addItem()
        
        self.clearsSelectionOnViewWillAppear = false
        
        let editButton = self.editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [editButton, addButton]
        
    }
    
    //go to login screen if logout tapped
    @IBAction func logoutTapped(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginScreen")
        
        self.present(controller, animated: true)
    }
    
    //add item to array
    func addItem()
    {
        items.append((itemName: itemNameNew, category: itemCategoryNew))
    }
    
    //go to add item screen when '+' pressed
    @objc func addTapped()
    {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddItemScreen")
        self.navigationController!.pushViewController(controller, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)

        // Configure the cell...provide the text and detailText
        cell.textLabel?.text = items[indexPath.row].itemName
        cell.detailTextLabel?.text = items[indexPath.row].category

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let temp = items[fromIndexPath.row]
        items.remove(at: fromIndexPath.row)
        items.insert(temp, at: to.row)
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // find the destination controller
        let dest = segue.destination as? ItemDetailsViewController
        // set its data members
        let selectedRow:Int = (self.tableView.indexPathForSelectedRow?.row)!
        dest?.itemName = items[selectedRow].itemName
        dest?.category = items[selectedRow].category
        dest?.date = dateNew
        dest?.warranty = warrantyNew
        dest?.amtPaid = amountNew
        dest?.sellerName = sellerNameNew
        dest?.sellerPhone = sellerPhoneNew
        dest?.sellerEmail = sellerEmailNew
        dest?.myImage = imageNew
    }

}
