//
//  NewPoemViewController.swift
//  Virs
//
//  Created by Greg Heggie on 11/14/17.
//  Copyright © 2017 Greg Heggie. All rights reserved.
//

import UIKit

class NewPoemViewController: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var poemText: UITextView!
    
    var date = ""
    var saveDate = ""
    var poemId = ""
    var newPoem: Poem = Poem.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleText.layer.borderColor = UIColor.init(red: 125/255, green: 91/255, blue: 166/255, alpha: 1).cgColor
        titleText.layer.borderWidth = 1.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func previewPoem(_ sender: UIButton) {
        if(titleText.text == "" || poemText.text == "") {
            let alertController = UIAlertController(title: "Empty Field(s)", message: "Try Again!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            // segue to poem controller with poem and put into correct fields
            performSegue(withIdentifier: "showPreview", sender: sender)
        }
    }
    
    func savePoem(){
        let title = "\(titleText.text!)"
        newPoem.title = title
        let poem = "\(poemText.text!)"
        newPoem.poem = poem
        newPoem.date = date
        newPoem.poet = currentUser.username
        poemId = "\(titleText.text! + saveDate)"
        newPoem.poemId = poemId
        newPoem.poetId = currentUser.userId
        newPoem.poetView = currentUser.userIcon
        newPoem.snapCount = 0
    }
    
    //  create poemId and Date
    func createPoemId(){
        let now = Date()
        
        let formatter = DateFormatter()
        let saveFormat = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        saveFormat.timeZone = TimeZone.current
        
        formatter.dateFormat = "MM/dd/yy-HH:mm:ss"
        saveFormat.dateFormat = "MMddyyyyhhmmss"
    
        date = formatter.string(from: now)
        saveDate = saveFormat.string(from: now)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let pvc: PoemViewController = segue.destination as! PoemViewController
        createPoemId()
        savePoem()
        pvc.thePoem = newPoem
        pvc.fromWhere = true
    }
}
