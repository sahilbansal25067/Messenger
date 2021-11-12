//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Sahil Kumar Bansal on 03/11/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
}
extension DatabaseManager{
    public func userExists(with email: String,
                           completion : @escaping((Bool)->Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard let _ = snapshot.value as? String else{
                completion(false)
                return
            }
            completion(true)
            
        })
        
    }
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser){
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
    
}
struct ChatAppUser{
    let firstName : String
    let lastName : String
    let emailAddress : String
    var safeEmail : String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
