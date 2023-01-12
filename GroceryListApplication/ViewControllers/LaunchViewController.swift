//
//  LaunchViewController.swift
//  GroceryListApplication
//
//  Created by Mohammed Alsiraji on 08/01/2023.
//

import UIKit
import FirebaseAuth
class LaunchViewController: UIViewController {
    //MARK: - Var
    var handler: AuthStateDidChangeListenerHandle?
    
    //MARK: - life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if handler != nil {return }
        //Auth listener for user status
        handler = Auth.auth().addStateDidChangeListener { auth, user in
            self.dismiss(animated: true)
            if user != nil {
                // if a user is logged in or signed up navigate to main page "GroceryListNavigationController"
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "GroceryListNavigationController") else {return}
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
            else {
                // if thier is no user present the register "RegisterNavigationController"
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "RegisterNavigationController") else {return}
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
