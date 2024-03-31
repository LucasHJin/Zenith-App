//
//  ProfileViewViewModel.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-02-04.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var dataPoints: [DataPoint] = []
    
    init() {}
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }

    }
    
    
    func retrieveInfo() {
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let database = Firestore.firestore()
        
        let reference = database.collection("users").document(uId)
        
        reference.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let name = data?["name"] as? String {
                    print("Name retrieved -> \(name)")
                    DispatchQueue.main.async {
                        self.name = name //setting name equal to it
                    }
                    print(name)
                } else {
                    print("Name field does not exist or is not a string")
                }
            } else {
                print("User document does not exist")
            }
        }
        
    }
    
    func retrievePoints(exercise: String) {
        dataPoints.removeAll()
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let database = Firestore.firestore()
        
        let exerciseRef = database.collection("users").document(uId).collection(exercise)


        exerciseRef.getDocuments { [weak self] querySnapshot, error in
            guard let self = self else { return } // Ensure self is not nil
            
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("Error: Query snapshot is nil")
                return
            }
            //print("1a")
            for document in querySnapshot.documents {
                //access document data
                //_ = document.data()

                var date = document.documentID
                let date2 = String(date.dropFirst(6))
                
                let RMRef = exerciseRef.document(date).collection("oneRepMax")
                
                //print("2a")
                RMRef.getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let querySnapshot = querySnapshot else {
                        print("Error: Query snapshot is nil")
                        return
                    }
                    //print("3a")
                    for document in querySnapshot.documents {

                        //print("4a")
                        //_ = document.data()
                        
                        let oneRM = document.documentID
                        //print(oneRM)
                        
                        let dataPoint = DataPoint(date: date2, RM: Double(oneRM) ?? 0)
                        //print(dataPoint, "  4a")
                        self.dataPoints.append(dataPoint)
                        //print(self.dataPoints, "ADF")
                    }
                }
                
                
                

            }
        }
        
    }
    
    
}
