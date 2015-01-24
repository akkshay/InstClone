//
//  loginViewController.swift
//  InstClone
//
//  Created by Akkshay Khoslaa on 1/5/15.
//  Copyright (c) 2015 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, dispError:String) {
        var alert = UIAlertController(title: "Error in form", message: dispError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    @IBOutlet weak var login_uname: UITextField!
    @IBOutlet weak var login_pword: UITextField!
    
    @IBAction func logIn(sender: AnyObject) {
        
        var dispError = ""
        if login_uname.text == "" || login_pword.text == "" {
            dispError = "Please enter a username or password"
            
        }
        
        if dispError != "" {
            displayAlert("Error in form", dispError: dispError)
            
        } else {
            var user = PFUser()
            user.username = login_uname.text
            user.password = login_pword.text
            // other fields can be set just like with PFObject
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        PFUser.logInWithUsernameInBackground(login_uname.text, password:login_pword.text) {
            (user: PFUser!, signupError: NSError!) -> Void in
            if signupError == nil {
                self.performSegueWithIdentifier("jumpToUserTableFromLogin", sender: self)
                println("Logged in")
            } else {
                // The login failed. Check error to see why.
                if let errorString = signupError.userInfo?["error"] as? NSString {
                    dispError = errorString
                } else {
                    dispError = "Please try again later"
                }
                self.displayAlert("Could Not Sign Up", dispError: dispError)
                
            }
        }
        }
    }
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("jumpToUserTableFromLogin", sender: self)
        }
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
