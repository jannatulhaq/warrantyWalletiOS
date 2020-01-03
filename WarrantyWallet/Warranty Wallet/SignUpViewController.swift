//
//  SignUpViewController.swift
//  Warranty Wallet
//
//  Created by Zaeni Hoque on 12/15/19.
//  Copyright © 2019 Zaeni Hoque. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //notifications
        // Step 1: Ask for permission
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        // Step 2: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Warranty Wallet"
        content.body = "Your product expires in 20 days"
        
        // Step 3: Create the notification trigger
        let date = Date().addingTimeInterval(7)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Step 4: Create the request
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Step 5: Register the request
        center.add(request) { (error) in
            // Check the error parameter and handle any errors
        }
       
    }
    
    // function attached to button to go to login screen
    @IBAction func goToLogin(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // function to create user with details provided
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //creating user on firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created successfully")
                //taking user to the login screen
                self.performSegue(withIdentifier: "toLoginScreen", sender: self)
                
            } else {
                print("Error creating user")
            }
        }
        
    }
    
}
