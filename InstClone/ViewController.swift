//
//  ViewController.swift
//  InstClone
//
//  Created by Akkshay Khoslaa on 1/2/15.
//  Copyright (c) 2015 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    func displayAlert(title:String, dispError:String) {
        var alert = UIAlertController(title: "Error in form", message: dispError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
   
    
    @IBOutlet weak var uname: UITextField!
    
    @IBOutlet weak var pword: UITextField!
   
    @IBAction func signup(sender: AnyObject) {
        var dispError = ""
        if uname.text == "" || pword.text == "" {
            dispError = "Please enter a username or password"
            
        }
        
        if dispError != "" {
            displayAlert("Error in form", dispError: dispError)
            
        } else {
            var user = PFUser()
            user.username = uname.text
            user.password = pword.text
            // other fields can be set just like with PFObject
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, signupError: NSError!) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if signupError == nil {
                    self.performSegueWithIdentifier("jumpToUserTableFromSignup", sender: self)
                    println("Signed up")
                } else {
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
        
   
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

