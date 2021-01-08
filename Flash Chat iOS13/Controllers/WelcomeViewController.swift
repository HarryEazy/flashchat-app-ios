//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Harry Camps

import UIKit



class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // right when view appears we hide the navigation bar for design purposes
    override func viewWillAppear(_ animated: Bool) {
        // call super() method is good practice when overriding
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    // right when the view is about to dissappear we turn on the navigation bar so it appears on other views
    override func viewWillDisappear(_ animated: Bool) {
        // call super() method is good practice when overriding 
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set title to blank to create animation for title
        titleLabel.text = ""
        // the text for the title
        let titleText = K.appName
        // index to create delay in loop
        var charIndex = 0.0
        // loop through string
        for letter in titleText {
            // 0.1 * charIndex to allow for the delay other
            // this creates a timer for each letter in string and the timers start almost straight away
            // we need a extra delay relevant to the letter in string therefore we do 0.1 * charIndex
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                // add each letter to title after delay
                self.titleLabel.text?.append(letter)
                
            }
            // increment charIndex
            charIndex += 1
        }
        
        
        
    }
    
    
}
