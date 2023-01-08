//
//  ViewController.swift
//  GroceryListApplication
//
//  Created by Mohammed Alsiraji on 08/01/2023.
//

import UIKit
import FirebaseAuth
class RegisterViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    
    @IBOutlet weak var errorTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

    }
    
    private func checkFieldsInput() -> Bool{
        if emailTextField == nil || passWordTextField == nil {
            // Show Alert
            creatAlert(title: "Field Empty", message: "Complete all Fields to continue")
        return false
        }
        else {
            return true
        }
    }
    
    
    @IBAction func logInButton(_ sender: UIButton) {
        if checkFieldsInput(){
            guard let email = emailTextField.text else {return}
            guard let pass = passWordTextField.text else {return}
            Auth.auth().signIn(withEmail: email , password: pass) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.creatAlert(title: "Error Log In", message: error.localizedDescription)
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
                }
                
            }
        }
        
    }
    
    public func creatAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "ok", style: .default)
        let actionCancel = UIAlertAction(title: "cancel", style: .cancel)
//        alert.addAction(action1)
        alert.addAction(actionCancel)
        present(alert, animated: true)
        
    }
    
    
    
}

