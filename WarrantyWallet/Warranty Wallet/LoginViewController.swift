//
//  LoginViewController.swift
//  Warranty Wallet
//
//  Created by Zaeni Hoque on 12/11/19.
//  Copyright © 2019 Zaeni Hoque. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // function to take user to sign up screen
    @IBAction func signUpButton(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignUpScreen")
            self.present(vc, animated: true, completion: nil)
    }
    
    //function to login user after credentials entered
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        //get email and password
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //login user if credentials are right
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User logged in successfully")
                //go to all items screen
                self.performSegue(withIdentifier: "toAllItemsScreen", sender: self)
            } else {
                print("Error loggin user in")
            }
        }
        
    }
    
}
