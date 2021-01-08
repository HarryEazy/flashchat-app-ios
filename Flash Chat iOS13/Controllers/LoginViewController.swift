//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Harry Camps

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        // create constants for email and password using if let statement
        if let password = passwordTextfield.text, let email = emailTextfield.text {
            // use firebase Auth to verify user with email and password
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    //
                    // add this error to a label to give user feedback after model
                    //
                    // localizedDescription shows user the error in their language
                    print(e.localizedDescription)
                } else {
                    // navigate to chat view controller
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
                
                
                
            }
            
            
        }
    }
    
}
