//
//  ViewController.swift
//  GroceryListApplication
//
//  Created by Mohammed Alsiraji on 08/01/2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore


class RegisterViewController: UIViewController {
    //MARK: - Vars
    var handle: AuthStateDidChangeListenerHandle?
    private let dbManager = DatabaseManager()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    //MARK: - lifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: - Register Authintecation
    
    @IBAction func logInButton(_ sender: UIButton) {
        if checkFieldsInput(){
            guard let email = emailTextField.text else {return}
            guard let pass = passWordTextField.text else {return}
            Auth.auth().signIn(withEmail: email , password: pass) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.creatAlert(title: "Error Log In", message: error.localizedDescription)
                }
                else{
                    self.view.backgroundColor = .green
                    
                }
            }
        }
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if checkFieldsInput(){
            guard let email = emailTextField.text else {return}
            guard let pass = passWordTextField.text else {return}
            Auth.auth().createUser(withEmail: email , password: pass) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.creatAlert(title: "Error Signing Up", message: error.localizedDescription)
                }else if let authResult = authResult{
                    print(authResult.description)
                }
            }
        }
        
    }
    private func checkFieldsInput() -> Bool{
        if emailTextField == nil || passWordTextField == nil {
            creatAlert(title: "Field Empty", message: "Complete all Fields to continue")
            return false
        }
        else {
            return true
        }
    }
    
    public func creatAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(actionCancel)
        present(alert, animated: true)
        
    }
    
    
    
}

