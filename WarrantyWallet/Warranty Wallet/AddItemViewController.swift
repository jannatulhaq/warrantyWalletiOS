//
//  AddItemViewController.swift
//  Warranty Wallet
//
//  Created by Zaeni Hoque on 12/15/19.
//  Copyright © 2019 Zaeni Hoque. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices
import AVFoundation
import Firebase
import FirebaseDatabase

var ref: DatabaseReference!

class AddItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate{
    
    
    @IBOutlet weak var ItemNameText: UITextField!
    @IBOutlet weak var sellerEmailText: UITextField!
    @IBOutlet weak var sellerNameText: UITextField!
    @IBOutlet weak var warrantyText: UITextField!
    @IBOutlet weak var amtPaidText: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    // cipher text
    let cipher = "100100"
    
    
    func uploadInfo(){
        uploadImage(self.myImageView.image!) { url in
            if self.myImageView != nil {
                self.saveImage(name: "reciept", profileURL: url!){ success in
                    if success != nil {
                        print("YES,YES")
                    }
                    
                }
            }
            
        }
    }
    
    //func when save button clicked
    @IBAction func SaveBtn(_ sender: UIButton) {
        uploadInfo()
        
        //after uploading all info into database, go back to all items screen
        self.performSegue(withIdentifier: "backToAllItems", sender: self)
    }

    //function to upload image to database
    func uploadImage(_ image: UIImage, completion: @escaping ((_ url: URL?)-> ())){
        let storageRef = Storage.storage().reference().child("myimage.png")
        let imgData = myImageView.image?.pngData()
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metadata){(metadata, error) in
            if error == nil{
                print("success")
                storageRef.downloadURL(completion: {(url, error) in
                    completion(url)
                })
            } else{
                print("error in save image")
                completion(nil)
            }
        }
    }
    
    //func to save image and other details into database
    func saveImage(name:String, profileURL:URL, completion: @escaping ((_ url: URL?)-> ())){
           ref = Database.database().reference()
        
        //encrypting variables before sending to database
        // encrypted variables
        let itemNameE = encryptDecrypt(input: ItemNameText.text! as NSString, staticKey: cipher as NSString)
        let itemCatE = encryptDecrypt(input: itemCategoryText.text! as NSString, staticKey: cipher as NSString)
        let dateE = encryptDecrypt(input: dateTextField.text! as NSString, staticKey: cipher as NSString)
        let warrantyE = encryptDecrypt(input: warrantyText.text! as NSString, staticKey: cipher as NSString)
        let sellerNameE = encryptDecrypt(input: sellerNameText.text! as NSString, staticKey: cipher as NSString)
        let sellerPhoneE = encryptDecrypt(input: txtMobileNum.text! as NSString, staticKey: cipher as NSString)
        let sellerEmailE = encryptDecrypt(input: sellerEmailText.text! as NSString, staticKey: cipher as NSString)
        let amtE = encryptDecrypt(input: amtPaidText.text! as NSString, staticKey: cipher as NSString)
        
        let info = [ "Date & Time bought": dateE! as String,
                     "Item Name": itemNameE! as String,
                     "Amount Paid": amtE! as String,
                     "Seller Name": sellerNameE! as String,
                     "Seller Email": sellerEmailE! as String,
                     "Seller Phone Number": sellerPhoneE! as String,
                     "Item Category": itemCatE! as String,
                     "Reciept Image": profileURL.absoluteString ,
                     "Warranty Period": warrantyE! as String
        ] as [String : Any]
        
            ref.child("items").childByAutoId().setValue(info)
    }
        
    // func to upload video
    @IBAction func videoUploadBtn(_ sender: UIButton) {
            let video = UIImagePickerController()
            video.delegate = self
            
            video.sourceType = UIImagePickerController.SourceType.photoLibrary
            video.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            
            //user wont be able to edit the image
            video.allowsEditing = false
            self.present(video,animated: true)
            {
                //after it is complete
            }
    }
    
    //func to allow user to pick a video
    func videoPickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl = info [UIImagePickerController.InfoKey.mediaURL] as? URL{
        print("videoURL:\(String(describing: videoUrl))")
        self.dismiss(animated: true, completion: nil)
    }
    }
    
    
    @IBOutlet weak var txtMobileNum: UITextField!
    // func to set conditions for values to be entered in phone field
    func textField(_ _textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String )-> Bool {
        let allowedCharacters = "+0123456789"
        let allowedCharacterSet = CharacterSet ( charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet ( charactersIn: string)
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private var datePicker: UIDatePicker?
    
    var pickerView = UIPickerView()
    @IBOutlet weak var itemCategoryText: UITextField!
    
    var list = ["Laptops", "Mobiles", "TV" , "Kitchen Products" , "Others"]
    
    @IBOutlet weak var myImageView: UIImageView!
    
    //func to upload image
    @IBAction func uploadImageBtn(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
           
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
           
        //user wont be able to edit the image
        image.allowsEditing = false
        self.present(image, animated: true)
        {
            //after it is complete
        }
    }
       
    //when the user has picked the image they r choosing
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
               myImageView.image = image
        }
        else
        {
            //error messsage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //align all text to center
        ItemNameText.textAlignment = .center
        amtPaidText.textAlignment = .center
        warrantyText.textAlignment = .center
        sellerNameText.textAlignment = .center
        txtMobileNum.textAlignment = .center
        sellerEmailText.textAlignment = .center
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        itemCategoryText.inputView = pickerView
        itemCategoryText.textAlignment = .center
        itemCategoryText.placeholder = "Select category"
        
        txtMobileNum.delegate = self
        
        dateTextField.textAlignment = .center
        dateTextField.placeholder = "Select date"
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddItemViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddItemViewController.viewTapped(gestureRecognizer:)))

        view.addGestureRecognizer(tapGesture)
        
        dateTextField.inputView = datePicker
    
    }
    
    //function to set date format and get date
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    //func to recognise user tap
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

        return list.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return list[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        itemCategoryText.text = list[row]
        itemCategoryText.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemsTableViewController
        destinationVC.itemNameNew = ItemNameText.text!
        destinationVC.itemCategoryNew = itemCategoryText.text!
        destinationVC.dateNew = dateTextField.text!
        destinationVC.amountNew = amtPaidText.text!
        destinationVC.warrantyNew = warrantyText.text!
        destinationVC.sellerNameNew = sellerNameText.text!
        destinationVC.sellerPhoneNew = txtMobileNum.text!
        destinationVC.sellerEmailNew = sellerEmailText.text!
        destinationVC.imageNew = myImageView.image
    }

    //func to encrypt values before putting into database
    func encryptDecrypt(input: NSString, staticKey: NSString) -> NSString? {
        let chars = (0..<input.length).map({
            input.character(at: $0) ^ staticKey.character(at: $0 % staticKey.length)
        })
        return NSString(characters: chars, length: chars.count)
    }
    
    //func to go to maps screen
    @IBAction func toMaps(_ sender: AnyObject) {

        let controller = storyboard!.instantiateViewController(withIdentifier: "MapsScreen")
               
    self.navigationController!.pushViewController(controller, animated: true)
    }
}

