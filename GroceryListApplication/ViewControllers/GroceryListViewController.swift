//
//  GroceryListViewController.swift
//  GroceryListApplication
//
//  Created by Mohammed Alsiraji on 08/01/2023.
//

import UIKit
import FirebaseAuth
class GroceryListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var list: [GroceryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

  
    }
    
    @IBAction func addItemToList(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter New Item Name"
            textField.delegate = self
        }
        let saveAction = UIAlertAction(title: "save", style: .default){[weak self] saveAction in
            guard let name = alertController.textFields?[0].text else {return}
            self?.creatNewItem(name: name)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    func creatNewItem(name: String){
        guard let userEmail = Auth.auth().currentUser?.email else {return}
        let newItem = GroceryItem(name: name, ceatedBy: userEmail)
        list.append(newItem)
        tableView.reloadData()
        
    }
    func editListItem(name: String ,indexPath: IndexPath){
        
        //guard let name = alertController.textFields?[0].text else {return}
        //self?.creatNewItem(name: name)
        guard let userEmail = Auth.auth().currentUser?.email else {return}
        list[indexPath.row].name = name
        list[indexPath.row].ceatedBy = userEmail
        tableView.reloadData()
        
    }
    func deleteListItem(indexPath: IndexPath){
        list.remove(at: indexPath.row)
        tableView.reloadData()
        
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
        cell.textLabel?.text = listItem.name
        cell.detailTextLabel?.text = listItem.ceatedBy
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
            guard let name = alertController.textFields?[0].text else {return}
            
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


struct GroceryItem{
    var name: String
    var ceatedBy: String
    
}
