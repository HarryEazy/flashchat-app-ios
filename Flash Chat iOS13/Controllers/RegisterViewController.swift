//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Harry Camps 


import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        // create constants for email and password using if let statement
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            // use firebase Auth to create user with email and password
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                // if error then print error
                if let e = error {
                    //
                    // add this error to a label to give user feedback after model
                    //
                    // localizedDescription shows user the error in their language
                    print(e.localizedDescription)
                // no error so direct to chat view
                } else {
                    // navigate to chat view controller
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
            
            
        }
        
        
        
        
    }
    
}
