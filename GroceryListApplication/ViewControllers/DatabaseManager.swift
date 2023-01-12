//
//  DatabaseManager.swift
//  GroceryListApplication
//
//  Created by Mohammed Alsiraji on 10/01/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class DatabaseManager{
    
    //MARK: - Vars
    static let groceryList = "grocerylist"
    static let userStatus = "online"
    private let db = Firestore.firestore()
    private let dbReal = Database.database().reference()
    
    //MARK: - Firebase realTime Database CRUD.
    // Create new item in the Database
    public func creatGroceryItem(itemName: String , completion: @escaping(Result<Bool,Error>) -> ()){
        
        guard let user = Auth.auth().currentUser else {return }
        guard let email = user.email else {return}
        let id = UUID().uuidString
        dbReal.child(DatabaseManager.groceryList).child(id).setValue(["itemId": id,"itemName" : itemName , "creatorEmail": email , "creatorId": user.uid]) { error, dbreference in
            if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.success(true))
            }
        }
    }
    
    // Update an item in the Database
    public func updateGroceryItem(item: GroceryItem, newName: String){
        dbReal.child(DatabaseManager.groceryList).child(item.itemId).updateChildValues(["itemName" : newName])
    }
    // delete an item from the Database
    public func deleteGroceryItem(item: GroceryItem){
        dbReal.child(DatabaseManager.groceryList).child(item.itemId).removeValue()
    }
    
    //MARK: - online users
    
    public func creatDataBaseUser(authUser: User, completion: @escaping(Result<Bool,Error>) -> ()){
        let userRef = dbReal.child(DatabaseManager.userStatus)
        let currntUserRef = userRef.child(authUser.uid)
        currntUserRef.setValue( ["email": authUser.email] )
        // Remove the user if they disconnect
        currntUserRef.onDisconnectRemoveValue()
    }
}

//MARK: - List and User Models
struct OnlineUser {
    let email: String
}

extension OnlineUser{
    init(_ dictionary:[String: Any]?) {
        self.email = dictionary?["email"] as? String ?? ""
    }
}

struct GroceryItem{
    let itemId: String
    var itemName: String
    let creatorEmail: String
    let creatorId: String
}

extension GroceryItem{
    init(_ dectionary:[String : Any]?) {
        self.itemName = dectionary?["itemName"] as? String ?? "no Name"
        self.itemId = dectionary?["itemId"] as? String ?? "no Name"
        self.creatorEmail = dectionary?["creatorEmail"] as? String ?? "no email"
        self.creatorId = dectionary?["creatorId"] as? String ?? "no user id"
    }
}
