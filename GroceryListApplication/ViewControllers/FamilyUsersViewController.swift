//
//  FamilyUsersViewController.swift
//  GroceryListApplication
//
//  Created by Mohammed Alsiraji on 08/01/2023.
//

import UIKit
import FirebaseAuth
class FamilyUsersViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
          try  Auth.auth().signOut()
        }catch{
            print("Error Signing Out: ", error.localizedDescription)
        }
    }
}
