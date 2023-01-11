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
    static let groceryList = "grocerylist"
    
    private let db = Firestore.firestore()
    private let dbReal = Database.database().reference()
   
    
    public func creatGroceryItem(itemName: String , completion: @escaping(Result<Bool,Error>) -> ()){
        
        guard let user = Auth.auth().currentUser else {return }
        guard let email = user.email else {return}
  //      let childRef = dbReal.child(DatabaseManager.groceryList)
//        let docRef = db.collection(DatabaseManager.groceryList).document()
        
        let id = UUID().uuidString
        dbReal.child(DatabaseManager.groceryList).child(id).setValue(["itemId": id,"itemName" : itemName , "creatorEmail": email , "creatorId": user.uid]) { error, dbreference in
            if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.success(true))
            }
        }
        
//
//        db.collection(DatabaseManager.groceryList).document(docRef.documentID).setData(["itemName" : itemName , "itemId": docRef.documentID , "creatorEmail": user.email ?? "" , "creatorId": user.uid]) {
//            (error) in
//            if let error = error {
//                completion(.failure(error))
//            }
//            else{
//                completion(.success(true))
//
//            }
//
//        }
        
        
        
    }
    
    public func updateGroceryItem(item: GroceryItem, newName: String){
    
        dbReal.child(DatabaseManager.groceryList).child(item.itemId).updateChildValues(["itemName" : newName])
        
        
        
    }
    public func deleteGroceryItem(item: GroceryItem){
        dbReal.child(DatabaseManager.groceryList).child(item.itemId).removeValue()
        
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


/*

 {
   "grocerylist": {
     "bread": {
       "creatorEmail": "",
       "creatorId": "",
       "itemId": "",
       "itemName": ""
     }
   }
 }

*/
