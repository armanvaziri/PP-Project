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
        usernameTextField.frame.size.height = 66
        passwordTextField.frame.size.height = 66
        loginButton.frame.size.height = 66
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        usernameTextField.cornerRadius = usernameTextField.frame.height / 2
        passwordTextField.cornerRadius = passwordTextField.frame.height / 2
        loginButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
        loginButton.layer.shadowOpacity = 0.05
        loginButton.layer.shadowRadius = 0.05
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
