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
        tableView.delegate = self
        tableView.dataSource = self
     

    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
          try  Auth.auth().signOut()
        }catch{
            print("Error Signing Out: ", error.localizedDescription)
        }
    }
}


extension FamilyUsersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "") as? UsersTableViewCell
        else {return UITableViewCell()}
        //cell.textLabel?.text =
        return cell
    }
    
    
    
}
