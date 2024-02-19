//
//  CreateAccountViewViewModel.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-02-04.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class CreateAccountViewViewModel: ObservableObject { //just OOP
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    
    init() {}
    
    
    private func validate() -> Bool {
        errorMessage = ""
        
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please ensure to fill in all the fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Please enter a password greater than 5 characters."
            return false
        }
        
        return true
        
    }
    
    
    func register() {
        guard validate() else {
            return //if validation doesn't work, it runs
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in //completion is checking for possible problems, i.e. already existing account?
            //When an event happens, trigger completion(). You can also pass values with this completion.
            //https://www.logilax.com/swift-weak-self/
            //self references object in class/struct
            guard let userID = result?.user.uid else {
                return
            } //occurs when let... is false -> that statement is saying if you can let the result(optional) equal the non-optional version of message (userID)
            
            self?.insertUserRecord(id: userID) //inserting user info into database
            //? because optional -> not sure if it has a value
        }
    }
    
    

    private func insertUserRecord(id: String) {
        let newUser = User(id: id,
                           name: name,
                           email: email) //can't directly save date object to firebase -> saving num of seconds since 1970
        
        let database = Firestore.firestore()
        //records are stored in firebase in documents and collection
        
        database.collection("users") // collection for all users
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    
    
    
    
    
    
}
