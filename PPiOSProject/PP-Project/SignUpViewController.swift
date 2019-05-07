//
//  SignUpiewController.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/6/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        view.set2GradientBackground(colorOne: UIColor.purple.withAlphaComponent(0.6), colorTwo: UIColor.blue.withAlphaComponent(0.6))
        emailTextField.frame.size.height = 66
        passwordTextField.frame.size.height = 66
        signupButton.frame.size.height = 66
        signupButton.layer.cornerRadius = signupButton.frame.height / 2
        emailTextField.cornerRadius = emailTextField.frame.height / 2
        passwordTextField.cornerRadius = passwordTextField.frame.height / 2
        passwordConfirmTextField.frame.size.height = 66
        passwordConfirmTextField.cornerRadius = passwordConfirmTextField.frame.height / 2
        signupButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
    }
    
    @objc func pulseButton(_ sender:UIButton) {
        sender.pulse()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordConfirmTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if passwordTextField.text != passwordConfirmTextField.text {
            
            let alertController = UIAlertController(title: "Password Incorrect", message: "Your passwords do not match", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
    }
    

    @IBAction func loginSegue(_ sender: UIButton) {
        performSegue(withIdentifier: "signupToLogin", sender: sender)
    }
    
    
    
}

