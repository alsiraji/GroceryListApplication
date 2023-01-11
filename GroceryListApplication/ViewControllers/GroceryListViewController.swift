//
//  GroceryListViewController.swift
//  GroceryListApplication
//
//  Created by Mohammed Alsiraji on 08/01/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class GroceryListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var listener: ListenerRegistration?
    private var handle: DatabaseHandle?
    private let dbManager = DatabaseManager()
    
    private var list = [GroceryItem](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

  
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        let value = snapshot.value as? NSDictionary
         Database.database().reference().child(DatabaseManager.groceryList).observe(.value) {snapshot in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {return}
            print("<<<<<<<<<<<<<<<<<<<<")
           // guard let item = children[0].value as? Dictionary<String, Any> else {return}
            
            //let newItem = GroceryItem(item)
            //print(children[0].key ,"Value",newItem)
            print("<<<<<<<<<<<<<<<<<<<<")
            let templist = children.map({
                GroceryItem($0.value as? Dictionary<String, Any>)
               // GroceryItem(item.value as! [String : Any])
            })
            
            self.list = templist
        }
        
        listener = Firestore.firestore().collection(DatabaseManager.groceryList).addSnapshotListener({ (snapshot,error) in
            if let error = error {
                print("error \(error.localizedDescription)")

            }else if let snapshot = snapshot{
                let dbList = snapshot.documents.map {
                    GroceryItem($0.data())

                }
             //   self.list = dbList
            }
        })
//
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       // listener?.remove()
        
        
    }
    
    
    
    @IBAction func addItemToList(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter New Item Name"
            textField.delegate = self
        }
        let saveAction = UIAlertAction(title: "save", style: .default){[unowned self] saveAction in
            guard let name = alertController.textFields?[0].text, !name.isEmpty  else {return}
            //self.creatNewItem(name: name)
            self.dbManager.creatGroceryItem(itemName: name) {[weak self] (result) in
                switch result{
                case .failure(let error):
                    print("error Creating list item: \(error.localizedDescription)")
                    
                case .success:
                    //fetch the database and updetae the table view
                    print("succefuly added")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    func creatNewItem(name: String){
        dbManager.creatGroceryItem(itemName: name) { result in
            switch result{
            case.failure(let error):
                print("error \(error.localizedDescription)")
            case.success:
                print("success")
            }
            
        }
        guard let userEmail = Auth.auth().currentUser?.email else {return}
//        let newItem = GroceryItem(name: name, ceatedBy: userEmail)
//        list.append(newItem)
        tableView.reloadData()
        
    }
    func editListItem(name: String ,indexPath: IndexPath){
        
       
        let item = list[indexPath.row]
        let newName = name
        dbManager.updateGroceryItem(item: item, newName: newName)
        tableView.reloadData()
        
    }
    func deleteListItem(indexPath: IndexPath){
        let item = list[indexPath.row]
        
        dbManager.deleteGroceryItem(item: item)
        
        //tableView.reloadData()
        
    }
    
    
  
}
extension GroceryListViewController: UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell
        else {return UITableViewCell()  }
        let listItem = list[indexPath.row]
        cell.textLabel?.text = listItem.itemName
        cell.detailTextLabel?.text = listItem.creatorEmail
        cell.textLabel?.font = .systemFont(ofSize: 32)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
            textField.delegate = self
        }
        let saveAction = UIAlertAction(title: "save", style: .default){[weak self] saveAction in
            guard let name = alertController.textFields?[0].text , !name.isEmpty else {return}
            
            self?.editListItem(name: name,indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
       
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      deleteListItem(indexPath: indexPath)
    }
    
    
    
}

extension GroceryListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}




struct onlineUser{
    let email: String
    var listItems: [GroceryItem]
    
    
    
}
