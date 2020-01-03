//
//  ItemDetailsViewController.swift
//  Warranty Wallet
//
//  Created by Zaeni Hoque on 12/15/19.
//  Copyright © 2019 Zaeni Hoque. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ItemDetailsViewController: UIViewController {
    
    var itemName:String = ""
    var category:String = ""
    var date:String = ""
    var warranty:String = ""
    var sellerName:String = ""
    var sellerPhone:String = ""
    var sellerEmail:String = ""
    var amtPaid:String = ""
    var myImage: UIImage!
    
    //var ref: DatabaseReference!
    var ref = Database.database().reference()
    
    var itemIDs = [String]()
    
    //cipher text
    let cipher = "100100"
    
    let itemNameDb: String = ""
    let itemCategoryDb: String = ""
    let dateDb: String = ""
    let warrantyDb: String = ""
    let amountDb: String = ""
    let sellerNameDb: String = ""
    let sellerPhoneDb: String = ""
    let sellerEmailDb: String = ""
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var datePurchasedTextField: UITextField!
    @IBOutlet weak var warrantyTextField: UITextField!
    @IBOutlet weak var sellerNameTextField: UITextField!
    @IBOutlet weak var sellerPhoneTextField: UITextField!
    @IBOutlet weak var sellerEmailTextField: UITextField!
    @IBOutlet weak var myNewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var handle: DatabaseHandle?

        let user = Auth.auth().currentUser

        ref = Database.database().reference()

        ref.child("items").observe(.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    var itemID = child.key as! String
                    self.itemIDs.append(itemID)
                }
            }
        })
        
        var lastItem = itemIDs.count
        
        let itemRef = self.ref.child("items").child(itemIDs[2])

        //get data from database
        itemRef.observeSingleEvent(of: .value, with: { snapshot in
            let itemDict = snapshot.value as! [String: Any]
            let itemNameDb = itemDict["Item Name"] as! String
            let itemCategoryDb = itemDict["Item Category"] as! String
            let dateDb = itemDict["Date & Time bought"] as! String
            let warrantyDb = itemDict["Warranty Period"] as! String
            let amountDb = itemDict["Amount Paid"] as! String
            let sellerNameDb = itemDict["Seller Name"] as! String
            let sellerPhoneDb = itemDict["Seller Phone Number"] as! String
            let sellerEmailDb = itemDict["Seller Email"] as! String
        })
        
        // decrypting recived data
        let itemNameD = encryptDecrypt(input: itemNameDb as NSString, staticKey: cipher as NSString)
        let itemCatD = encryptDecrypt(input: itemCategoryDb as NSString, staticKey: cipher as NSString)
        let warrantyD = encryptDecrypt(input: warrantyDb as NSString, staticKey: cipher as NSString)
        let dateD = encryptDecrypt(input: dateDb as NSString, staticKey: cipher as NSString)
        let amtD = encryptDecrypt(input: amountDb as NSString, staticKey: cipher as NSString)
        let sellerNameD = encryptDecrypt(input: sellerNameDb as NSString, staticKey: cipher as NSString)
        let sellerPhoneD = encryptDecrypt(input: sellerPhoneDb as NSString, staticKey: cipher as NSString)
        let sellerEmailD = encryptDecrypt(input: sellerEmailDb as NSString, staticKey: cipher as NSString)
        
        // Do any additional setup after loading the view.
        itemNameTextField.text = itemName
        categoryTextField.text = category
        datePurchasedTextField.text = date
        warrantyTextField.text = warranty
        sellerNameTextField.text = sellerName
        sellerPhoneTextField.text = sellerPhone
        sellerEmailTextField.text = sellerEmail
        myNewImage.image = myImage
        
        //disable editing unless stated by user
        itemNameTextField.isUserInteractionEnabled = false
        categoryTextField.isUserInteractionEnabled = false
        datePurchasedTextField.isUserInteractionEnabled = false
        warrantyTextField.isUserInteractionEnabled = false
        sellerNameTextField.isUserInteractionEnabled = false
        sellerPhoneTextField.isUserInteractionEnabled = false
        sellerEmailTextField.isUserInteractionEnabled = false

        // to enable editing
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

    @objc func editButtonPressed(_ sender: Any) { let tempButton = sender as? UIBarButtonItem
        if tempButton?.title == "Edit"
    {
        itemNameTextField.isUserInteractionEnabled = true
        categoryTextField.isUserInteractionEnabled = true
        datePurchasedTextField.isUserInteractionEnabled = true
        warrantyTextField.isUserInteractionEnabled = true
        sellerNameTextField.isUserInteractionEnabled = true
        sellerPhoneTextField.isUserInteractionEnabled = true
        sellerEmailTextField.isUserInteractionEnabled = true
        
        tempButton?.title = "Done"
    }
    
    else {
        itemNameTextField.isUserInteractionEnabled = false
        categoryTextField.isUserInteractionEnabled = false
        datePurchasedTextField.isUserInteractionEnabled = false
        warrantyTextField.isUserInteractionEnabled = false
        sellerNameTextField.isUserInteractionEnabled = false
        sellerPhoneTextField.isUserInteractionEnabled = false
        sellerEmailTextField.isUserInteractionEnabled = false
            
        tempButton?.title = "Edit"
        itemName = itemNameTextField.text!
        category = categoryTextField.text!
        date = datePurchasedTextField.text!
        warranty = warrantyTextField.text!
        sellerName = sellerNameTextField.text!
        sellerPhone = sellerPhoneTextField.text!
        sellerEmail = sellerEmailTextField.text!
        
    } }
    
    //function to decrypt values from database
    func encryptDecrypt(input: NSString, staticKey: NSString) -> NSString? {
        let chars = (0..<input.length).map({
            input.character(at: $0) ^ staticKey.character(at: $0 % staticKey.length)
        })
        return NSString(characters: chars, length: chars.count)
    }
}
