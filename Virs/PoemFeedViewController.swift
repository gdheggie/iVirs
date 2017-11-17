//
//  FirstViewController.swift
//  Virs
//
//  Created by Greg Heggie on 11/11/17.
//  Copyright © 2017 Greg Heggie. All rights reserved.
//

import UIKit
import Firebase
import PINRemoteImage

var currentUser = Poet.init()

class PoemFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var poems: [Poem] = []
    var aPoem = Poem.init()
    var databaseRef: DatabaseReference!
    var poetClicked: Poet = Poet.init()
    var poemClicked: Poem = Poem.init()
    var selected: Int = -1
    
    @IBOutlet weak var poemFeedTable: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        databaseRef = Database.database().reference()
        getUser(tableClick: false)
        showPoems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUser(tableClick: Bool){
        databaseRef.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let userID = snapshot.value as! NSDictionary
                for ids in userID.allKeys {
                    if tableClick == false {
                    if Auth.auth().currentUser?.uid == ids as? String {
                        let id = ids as! String
                        let thisUser = userID.value(forKey: id) as! NSDictionary
                        currentUser.username = thisUser.value(forKey: "username")! as! String
                        currentUser.userIcon = thisUser.value(forKey: "userIcon")! as! String
                        currentUser.userId = thisUser.value(forKey: "userId")! as! String
                        if let userPoems = thisUser.value(forKey: "poems") as? [String] {
                            currentUser.snappedPoems = userPoems
                        } else {
                            let userNewPoems: [String] = []
                            currentUser.snappedPoems = userNewPoems
                        }
                        if let userSnaps = thisUser.value(forKey: "snappedPoems") as? [String] {
                            currentUser.snappedPoems = userSnaps
                        } else {
                            let userNewSnaps: [String] = []
                            currentUser.snappedPoems = userNewSnaps
                        }
                    }
                } else {
                        if self.poems[self.selected].poetId == ids as? String {
                            let id = ids as! String
                            let thisUser = userID.value(forKey: id) as! NSDictionary
                            self.poetClicked.username = thisUser.value(forKey: "username")! as! String
                            self.poetClicked.userIcon = thisUser.value(forKey: "userIcon")! as! String
                            self.poetClicked.userId = thisUser.value(forKey: "userId")! as! String
                            self.poetClicked.poems =  (thisUser.value(forKey: "poems") as? [String])!
                            if let userSnaps = thisUser.value(forKey: "snappedPoems") as? [String] {
                                self.poetClicked.snappedPoems = userSnaps
                            } else {
                                let userNewSnaps: [String] = []
                                self.poetClicked.snappedPoems = userNewSnaps
                            }
                        }
                    }
                }
                if self.poetClicked.username != "..." {
                    self.performSegue(withIdentifier: "showUser", sender: self)
                }
            }
        }
    }
    
    func showPoems(){
        var count = 0
        databaseRef.child("Poems").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
               let poemIds = snapshot.value as! NSDictionary
                for ids in poemIds.allKeys{
                   let id = ids as! String
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
                self.poemFeedTable.reloadData()
            }
        }
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
        poems.removeAll()
        showPoems()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "poem_cell", for: indexPath) as! PoemViewCell
        
        // Configure the cell
        if(poems[indexPath.row].snapCount == 1) {
            cell.snapLabel.text = "\(poems[indexPath.row].snapCount) \nSnap"
        } else {
        cell.snapLabel.text = "\(poems[indexPath.row].snapCount) \nSnaps"
        }
        
        cell.usernameLabel.text = poems[indexPath.row].poet
        cell.usernameLabel.tag = indexPath.row
        usernameTap(userLabel: cell.usernameLabel)
        cell.poemPreviewLabel.text = poems[indexPath.row].poem
        cell.poemPreviewLabel.tag = indexPath.row
        poemTap(poem: cell.poemPreviewLabel)
        cell.poetView.tag = indexPath.row
        if poems[indexPath.row].poetId != "" {
            cell.poetView.pin_setImage(from: URL(string: poems[indexPath.row].poetId))
            imageTap(img: cell.poetView)
        }
    
        // return cell
        return cell
    }
    
    // image gesture start
    func imageTap(img: UIImageView) {
        let userTapped = UITapGestureRecognizer(target: self, action: #selector(self.imgTapGesture(_:)))
        img.addGestureRecognizer(userTapped)
    }
    
    @objc func imgTapGesture(_ sender: UITapGestureRecognizer) {
        selected = (sender.view?.tag)!
        getUser(tableClick: true)
    }
    
    // username label gesture start
    func usernameTap(userLabel: UILabel) {
        let userTapped = UITapGestureRecognizer(target: self, action: #selector(self.usernameTapGesture(_:)))
        userLabel.addGestureRecognizer(userTapped)
    }
    
    @objc func usernameTapGesture(_ sender: UITapGestureRecognizer) {
        selected = (sender.view?.tag)!
        getUser(tableClick: true)
    }
    
    // poem gesture start
    func poemTap(poem: UILabel) {
        let userTapped = UITapGestureRecognizer(target: self, action: #selector(self.poemTapGesture(_:)))
        poem.addGestureRecognizer(userTapped)
    }
    
    @objc func poemTapGesture(_ sender: UITapGestureRecognizer) {
        selected = (sender.view?.tag)!
        poemClicked = poems[selected]
        performSegue(withIdentifier: "showThePoem", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white
        selected = indexPath.row
        getUser(tableClick: true)
    }
    
    @IBAction func startStream(_ sender: UIButton) {
        forBeta()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showThePoem" {
            let pvc: PoemViewController = segue.destination as! PoemViewController
            pvc.thePoem = poemClicked
            pvc.fromWhere = false
        } else if segue.identifier == "showUser" {
            let upvc: UserProfileViewController = segue.destination as! UserProfileViewController
            upvc.otherPoet = poetClicked
        }
    }
    
    func forBeta(){
        let alertController = UIAlertController(title: "Coming with Beta Release!", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

