//
//  LaunchViewController.swift
//  GroceryListApplication
//
//  Created by Mohammed Alsiraji on 08/01/2023.
//

import UIKit
import FirebaseAuth
class LaunchViewController: UIViewController {
    var handler: AuthStateDidChangeListenerHandle?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if handler != nil {return }
        handler = Auth.auth().addStateDidChangeListener { auth, user in
            print("Auth status changed")
            print(auth)
            print(user?.email)
            
            self.dismiss(animated: true)
            if user != nil {
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "GroceryListNavigationController") else {return}
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
                
            }
            else {
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
