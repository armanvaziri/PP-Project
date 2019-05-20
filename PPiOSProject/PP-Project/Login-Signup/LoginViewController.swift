//
//  LoginViewController.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/6/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var gradient: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewload()
        loginButtonUI()
        usernameTextFieldUI()
        passwordTextFieldUI()
        
    }
    
    // UI customization
    
    func viewload() {
        view.set2GradientBackground(colorOne: UIColor.white.withAlphaComponent(0.6), colorTwo:
            UIColor.blue.withAlphaComponent(0.6))
        
    }
    
    func usernameTextFieldUI() {
        usernameTextField.delegate = self
        usernameTextField.placeholder = "EMAIL"
        usernameTextField.borderStyle = .none
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.textColor = UIColor.white
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 35, width: usernameTextField.frame.width, height: 2.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        usernameTextField.borderStyle = UITextField.BorderStyle.none
        usernameTextField.layer.addSublayer(bottomLine)
        
    }
    
    func passwordTextFieldUI() {
        passwordTextField.delegate = self
        passwordTextField.placeholder = "PASSWORD"
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.textColor = UIColor.white
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: 35, width: passwordTextField.frame.width, height: 2.0)
        bottomLine2.backgroundColor = UIColor.white.cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(bottomLine2)
        
        
    }
    
    func loginButtonUI() {
        loginButton.frame.size.height = 55
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
        loginButton.layer.shadowOpacity = 0.05
        loginButton.layer.shadowRadius = 0.05
        
    }
    
    @objc func pulseButton(_ sender:UIButton) {
        sender.pulse()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
        
    }
    
    
    // Signs in the user to Firebase database
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil{
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
            else{
                print(error.debugDescription)
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }

    }

    
    // Segues
    
    @IBAction func signupSegue(_ sender: UIButton) {
        performSegue(withIdentifier: "loginToSignup", sender: sender)
    }
    
}
