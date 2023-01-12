//
//  FamilyUsersViewController.swift
//  GroceryListApplication
//
//  Created by Mohammed Alsiraji on 08/01/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FamilyUsersViewController: UIViewController {
    //MARK: - Vars
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var onlineUsers = [OnlineUser](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Refrence to observe online users changes
        Database.database().reference().child(DatabaseManager.userStatus).observe(.value) { (snapshot) in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {return}
            let templist = children.map({
                OnlineUser($0.value as? Dictionary<String, Any>)
            })
            // the List will be updated accurding to the observer data each time
            self.onlineUsers = templist
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    //MARK: - Sign Out
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        guard let user = Auth.auth().currentUser else {return}
        let onlineRef = Database.database().reference().child(DatabaseManager.userStatus).child(user.uid)
        onlineRef.removeValue { (error, _) in
            if let error = error{
                print("error \(error.localizedDescription)")
            }
        }
        do {
            try  Auth.auth().signOut()
        }
        catch{
            print("Error Signing Out: ", error.localizedDescription)
        }
    }
}
//MARK: - TableView Delegate&DataSource

extension FamilyUsersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        onlineUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell") as? UsersTableViewCell
        else {return UITableViewCell()}
        cell.textLabel?.text = onlineUsers[indexPath.row].email
        return cell
    }
}
