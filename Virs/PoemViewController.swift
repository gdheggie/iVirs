//
//  PoemViewController.swift
//  Virs
//
//  Created by Greg Heggie on 11/14/17.
//  Copyright © 2017 Greg Heggie. All rights reserved.
//

import UIKit
import Firebase

class PoemViewController: UIViewController {

    @IBOutlet weak var poetPic: UIImageView!
    @IBOutlet weak var poemDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var poetNameLabel: UILabel!
    @IBOutlet weak var poemView: UITextView!
    @IBOutlet weak var snapLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var thePoem: Poem?
    var fromWhere: Bool?
    var databaseRef: DatabaseReference!
    var uploadedPoem : [String : AnyObject] = [:]
    var currentPoet : [String : AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleLabel.text = thePoem?.title
        poetNameLabel.text = "by : " + thePoem!.poet
        let poemDate = thePoem!.date
        let topDate = poemDate.index(of: "-") ?? poemDate.endIndex
        let firstDate = poemDate[..<topDate]
        poemDateLabel.text = "created : " + String(firstDate)
        poemView.text = thePoem?.poem
        if thePoem?.snapCount == 1{
            snapLabel.text = "\(thePoem!.snapCount) snap"
        }else {
        snapLabel.text = "\(thePoem!.snapCount) snaps"
        }
        
        if fromWhere == true {
            // delete button for currentUser
            deleteButton.isHidden = true
            uploadButton.isHidden = false
        } else {
            if thePoem?.poetId == currentUser.userId {
                deleteButton.isHidden = false
            } else {
                deleteButton.isHidden = true
            }
            uploadButton.isHidden = true
        }
        
        poetPic.layer.cornerRadius = poetPic.frame.size.width / 2
        poetPic.clipsToBounds = true
        poetPic.layer.borderWidth = 2.0
        poetPic.layer.borderColor = UIColor.init(red: 125/255, green: 91/255, blue: 166/255, alpha: 1).cgColor
        
        poetPic.pin_setImage(from: URL(string: thePoem!.poetView))
        
        databaseRef = Database.database().reference()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        poemView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func snapPoem(_ sender: UIButton) {
        forBeta()
    }
    
    @IBAction func sharePoem(_ sender: UIButton) {
        forBeta()
    }
    
    func forBeta(){
        let alertController = UIAlertController(title: "Coming with Beta Release!", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func uploadPoem(_ sender: UIButton) {
        // save poem to firebase
        
//        uploadedPoem.updateValue(([
//            "title" : thePoem?.title as Any,
//            "poem" : thePoem?.poem as Any,
//            "poet" : thePoem?.poet as Any,
//            "date" : thePoem?.date as Any,
//            "poemId" : thePoem?.poemId as Any,
//            "poetId" : thePoem?.poetId as Any,
//            "poetView" : thePoem?.poetView as Any,
//            "snapCount" : thePoem?.snapCount as Any] as NSDictionary), forKey: (thePoem?.poemId)!)
//
//        databaseRef.updateChildValues(uploadedPoem)
//
//        currentUser.poems.append((thePoem?.poemId)!)
//        currentPoet.updateValue(([
//                "username" : currentUser.username as Any,
//                "userId" : currentUser.userId as Any,
//                "userIcon" : currentUser.userIcon as Any,
//                "poems" : currentUser.poems as Any,
//                "snappedPoems" : currentUser.snappedPoems] as NSDictionary) , forKey: currentUser.userId)
//
//        databaseRef.updateChildValues(currentPoet)
        
        performSegue(withIdentifier: "donePoem", sender: self)
    }
    
    @IBAction func deletePoem(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Delete " + (thePoem?.title)!, message: nil, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.deleteThisPoem()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteThisPoem(){
//        var count = 0
//        databaseRef.child("Poems").child((thePoem?.poemId)!).removeValue()
//        databaseRef.child("Users").child((currentUser.userId)).removeValue()
//        for poem in currentUser.poems {
//            if(poem == thePoem?.poemId) {
//                currentUser.poems.remove(at: count)
//            }
//            count += 1
//        }
//        databaseRef.child("Users").child((currentUser.userId)).setValue(currentPoet, forKey: currentUser.userId)
//    }
    }
}
