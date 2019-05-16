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
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var gradient: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        view.set2GradientBackground(colorOne: UIColor.white.withAlphaComponent(0.6), colorTwo:
        UIColor.blue.withAlphaComponent(0.6))
//        usernameTextField.frame.size.height = 55
//        passwordTextField.frame.size.height = 55
        loginButton.frame.size.height = 55
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
//        usernameTextField.cornerRadius = usernameTextField.frame.height / 2
//        passwordTextField.cornerRadius = passwordTextField.frame.height / 2
        loginButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
        loginButton.layer.shadowOpacity = 0.05
        loginButton.layer.shadowRadius = 0.05
        
        usernameTextField.placeholder = "EMAIL"
        passwordTextField.placeholder = "PASSWORD"
        usernameTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        usernameTextField.backgroundColor = UIColor.clear
        passwordTextField.backgroundColor = UIColor.clear
        usernameTextField.textColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 35, width: usernameTextField.frame.width, height: 2.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: 35, width: passwordTextField.frame.width, height: 2.0)
        bottomLine2.backgroundColor = UIColor.white.cgColor
        
        usernameTextField.borderStyle = UITextField.BorderStyle.none
        usernameTextField.layer.addSublayer(bottomLine)
//        self.view.addSubview(usernameTextField)
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(bottomLine2)
//        self.view.addSubview(passwordTextField)
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
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
    
    @objc func pulseButton(_ sender:UIButton) {
        sender.pulse()
    }
    
    @IBAction func signupSegue(_ sender: UIButton) {
        performSegue(withIdentifier: "loginToSignup", sender: sender)
    }
    
    // UITextFieldDelegate Methods
    

}
