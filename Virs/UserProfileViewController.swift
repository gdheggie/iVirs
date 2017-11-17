//
//  UserProfileViewController.swift
//  Virs
//
//  Created by Greg Heggie on 11/11/17.
//  Copyright © 2017 Greg Heggie. All rights reserved.
//

import UIKit
import Firebase
import PINRemoteImage

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var poemCount: UILabel!
    @IBOutlet weak var snapCount: UILabel!
    @IBOutlet weak var userPoemsTable: UITableView!
    @IBOutlet weak var poetPicture: UIImageView!
    @IBOutlet weak var snappedButton: UIButton!
    @IBOutlet weak var poemsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var poetName: UILabel!
    
    var otherPoet: Poet?
    var databaseRef: DatabaseReference!
    var aPoem = Poem.init()
    var poems: [Poem] = []
    var poemClicked = Poem.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        poetPicture.layer.cornerRadius = poetPicture.frame.size.width / 2
        poetPicture.clipsToBounds = true
        poetPicture.layer.borderWidth = 2.0
        poetPicture.layer.borderColor = UIColor.white.cgColor
        poemsButton.backgroundColor = UIColor.gray
        userPoemsTable.isHidden = false
        
        databaseRef = Database.database().reference()
        
        if otherPoet?.username != nil {
            showPoems(poet: otherPoet!)
            poetPicture.pin_setImage(from: URL(string: (otherPoet?.userIcon)!))
            poemCount.text = "\(otherPoet?.poems.count ?? 00)"
            settingsButton.isHidden = true
            logoutButton.setImage(UIImage(named: "appleback"), for: .normal)
            poetName.text = otherPoet?.username
        } else {
            showPoems(poet: currentUser)
            poetPicture.pin_setImage(from: URL(string: currentUser.userIcon))
            poetName.text = currentUser.username
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        otherPoet = nil
    }
    
    @IBAction func signOutOfVirs(_ sender: UIButton) {
        
        if(sender.currentImage == UIImage(named: "appleback")) {
            self.dismiss(animated: true, completion: nil)
        } else {
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            }
            catch let signOutError as NSError {
                print(signOutError)
            }
        }
    }
    
    func showPoems(poet: Poet){
        var count = 0
        databaseRef.child("Poems").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let poemIds = snapshot.value as! NSDictionary
                for ids in poemIds.allKeys{
                    let id = ids as! String
                    if(poet.poems.contains(id)) {
                        let thisPoem = poemIds.value(forKey: id) as! NSDictionary
                        self.aPoem.title = thisPoem.value(forKey: "title")! as! String
                        self.aPoem.poem = thisPoem.value(forKey: "poem")! as! String
                        self.aPoem.date = thisPoem.value(forKey: "date")! as! String
                        self.aPoem.poemId = thisPoem.value(forKey: "poemId")! as! String
                        self.aPoem.poet = thisPoem.value(forKey: "poet")! as! String
                        self.aPoem.poetId = thisPoem.value(forKey: "poetId")! as! String
                        self.aPoem.poetView = thisPoem.value(forKey: "poetView")! as! String
                        self.aPoem.snapCount = thisPoem.value(forKey: "snapCount")! as! Int
                        self.poems.append(self.aPoem)
                        count += 1
                        self.aPoem = Poem.init()
                    }
                }
                self.userPoemsTable.reloadData()
                self.poemCount.text = "\(self.poems.count)"
                var snaps = 0
                for snap in self.poems {
                    snaps += snap.snapCount
                }
                self.snapCount.text = "\(snaps)"
            }
        }
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        forBeta()
    }
    
    @IBAction func showSnappedList(_ sender: UIButton) {
        snappedButton.backgroundColor = UIColor.gray
        poemsButton.backgroundColor = UIColor.init(red: 125/255, green: 91/255, blue: 166/255, alpha: 1)
        forBeta()
        userPoemsTable.isHidden = true
    }
    
    @IBAction func showPoemsList(_ sender: UIButton) {
        poemsButton.backgroundColor = UIColor.gray
        snappedButton.backgroundColor = UIColor.init(red: 125/255, green: 91/255, blue: 166/255, alpha: 1)
        userPoemsTable.isHidden = false
    }
    
    func forBeta(){
        let alertController = UIAlertController(title: "Coming with Beta Release!", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user_cell", for: indexPath)
        
        cell.textLabel?.text = poems[indexPath.row].title
        let poemDate = poems[indexPath.row].date
        let topDate = poemDate.index(of: "-") ?? poemDate.endIndex
        let firstDate = poemDate[..<topDate]
        cell.detailTextLabel?.text = String(firstDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white
        poemClicked = poems[indexPath.row]
        performSegue(withIdentifier: "userPoem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pvc: PoemViewController = segue.destination as! PoemViewController
        pvc.thePoem = poemClicked
        pvc.fromWhere = false
    }
}
