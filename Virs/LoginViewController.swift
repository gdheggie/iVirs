//
//  LoginViewController.swift
//  Virs
//
//  Created by Greg Heggie on 11/11/17.
//  Copyright © 2017 Greg Heggie. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Auth.auth().addStateDidChangeListener {auth, user in
            if user != nil{
              self.performSegue(withIdentifier: "toPoems", sender: self)
            }
        }
    }
    
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func signInToVirs(_ sender: UIButton) {
        if emailTextField.text != "" || passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if user != nil {
                self.performSegue(withIdentifier: "toPoems", sender: sender)
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                } else {
                    let alertController = UIAlertController(title: "Incorrect Credentials", message: "Please try again", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            let alertController = UIAlertController(title: "Empty Field(s)", message: "Please enter your email AND password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func signInTwitter(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Coming with Beta Release!", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpWithVirs(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUp", sender: sender)
    }
    
}
