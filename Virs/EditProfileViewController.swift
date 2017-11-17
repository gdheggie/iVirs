//
//  EditProfileViewController.swift
//  Virs
//
//  Created by Greg Heggie on 11/11/17.
//  Copyright © 2017 Greg Heggie. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    var currentPoet : [String : AnyObject] = [:]
    var databaseRef: DatabaseReference!
    var userNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        databaseRef = Database.database().reference()
        
        checkUsername()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profilePicture(_ sender: Any) {
        let alertController = UIAlertController(title: "Coming with Beta Release!", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkUsername(){
        databaseRef.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let userID = snapshot.value as! NSDictionary
                for ids in userID.allKeys {
                    let id = ids as! String
                    let thisUser = userID.value(forKey: id) as! NSDictionary
                    let usernameFound = thisUser.value(forKey: "username")! as! String
                    self.userNames.append(usernameFound)
                }
            }
        }
    }
    
    @IBAction func finishEdit(_ sender: UIButton) {
        // save user and go to main feed
            let username = usernameTextField.text
            if username != "" {
                
                if userNames.contains(username!) {
                    print(userNames)
                    print(username! + "THIS ONE")
                let alertController = UIAlertController(title: "That username already exists", message: "Try Again", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in
                        self.usernameTextField.text = ""
                    })
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            } else {
            
                let userId = Auth.auth().currentUser?.uid
                let newPoems: [String] = []
                let snapPoems: [String] = []
            
                currentPoet.updateValue(([
                    "username" : username as Any,
                    "userId" : userId as Any,
                    "userIcon" : "" as Any,
                    "poems" : newPoems as Any,
                    "snappedPoems" : snapPoems] as NSDictionary) , forKey: userId!)
            
                databaseRef.child("Users").updateChildValues(currentPoet)
                
                performSegue(withIdentifier: "toPoems", sender: sender)
                }
                
            } else {
                let alertController = UIAlertController(title: "Enter A Username", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
        }
    }
}
