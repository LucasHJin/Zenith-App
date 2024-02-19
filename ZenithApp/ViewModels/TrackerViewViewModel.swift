//
//  TrackerViewViewModel.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-02-04.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class TrackerViewViewModel: ObservableObject {
    @Published var exercises: [TrackedExercise] = []
    @Published var setNumber: Int = 1
    @Published var rowNumbers: [String: String] = [:]
    
    @Published var exerciseName: String = ""
    @Published var reps: String = ""
    @Published var weight: String = ""
    @Published var comments: String = ""
    @Published var workoutDate: Date = Date()
    @Published var warning = false
    

    init() {}
    
    
    func delete(exercise: TrackedExercise, date: Date) {
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let database = Firestore.firestore()
        
        
        let reference = database.collection("users").document(uId).collection(dateString).document(exercise.exerciseName).collection("sets").document(String(exercise.setNumber))
        
        reference.delete()
        
        
        
        
    }
    
    func fetchExercises(date: Date) {
        exercises.removeAll()

        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

        let database = Firestore.firestore()


        let topLevelCollectionRef = database.collection("users").document(uId).collection(dateString)


        topLevelCollectionRef.getDocuments { [weak self] topLevelSnapshot, topLevelError in
            guard let self = self else { return } //ensure self is not nil

            if let topLevelError = topLevelError {
                print("Error fetching top-level documents: \(topLevelError.localizedDescription)")
                return
            }

            guard let topLevelSnapshot = topLevelSnapshot else {
                print("Error: Top-level snapshot is nil")
                return
            }


            if !topLevelSnapshot.isEmpty {
                //iterate through documents in the top-level collection
                for document in topLevelSnapshot.documents {
                    //get the document ID (exercise name)
                    let exerciseName = document.documentID

                    //get the reference to the nested collection (sets)
                    let nestedCollectionRef = topLevelCollectionRef.document(exerciseName).collection("sets")

                    //fetch documents from the nested collection
                    nestedCollectionRef.getDocuments { nestedSnapshot, nestedError in
                        if let nestedError = nestedError {
                            print("Error fetching nested documents: \(nestedError.localizedDescription)")
                            return
                        }

                        guard let nestedSnapshot = nestedSnapshot else {
                            print("Error: Nested snapshot is nil")
                            return
                        }

                        //check if documents exist in the nested collection
                        if !nestedSnapshot.isEmpty {
                            // process documents in the nested collection
                            for nestedDocument in nestedSnapshot.documents {
                                let data = nestedDocument.data()

                                let setNumber = data["setNumber"] as? Int ?? 1
                                let id = data["id"] as? String ?? ""
                                let exerciseName = data["exerciseName"] as? String ?? ""
                                let reps = data["reps"] as? String ?? ""
                                let weight = data["weight"] as? String ?? ""
                                let comments = data["comments"] as? String ?? ""
                                
                                let exercise = TrackedExercise(setNumber: setNumber, id: id, exerciseName: exerciseName, reps: reps, weight: weight, comments: comments)
                                self.exercises.append(exercise)
                                
                                
                            }
                        } else {
                            print("No documents found in nested collection")
                        }
                    }
                }
            } else {
                print("No documents found in top-level collection")
            }
        }
    }
    
    
    
    
    func createExercise(date: Date) {
        guard canCreate else {
            return
        }

        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

        let newId = UUID().uuidString

        let database = Firestore.firestore()
        let referenceForDate = database.collection("users").document(uId).collection(dateString)

        referenceForDate.document(exerciseName).getDocument { [weak self] (snapshot, error) in
            guard let self = self else { return } 

            if let error = error {
                print("Error getting document: \(error.localizedDescription)")
                return
            }

            // if document doesn't exist or is empty, add dummy data
            if snapshot == nil || !snapshot!.exists {
                referenceForDate.document(exerciseName).setData(["dummy": "dummy"]) { error in
                    if let error = error {
                        print("Error adding dummy data: \(error.localizedDescription)")
                    } else {
                        print("Dummy data added successfully")
                        // continue with creating the new exercise after adding dummy data
                        self.continueCreatingExercise(uId: uId, dateString: dateString, newId: newId)
                    }
                }
            } else {
                //if document exists, continue with creating the new exercise
                self.continueCreatingExercise(uId: uId, dateString: dateString, newId: newId)
            }
        }
    }

    func continueCreatingExercise(uId: String, dateString: String, newId: String) {
        //get max set number
        getMaxSetNumber(uId: uId, dateString: dateString) { [weak self] maxSetNumber in
            guard let self = self else { return }

            //increment set number
            let setNumber = maxSetNumber + 1
            
            //create the new exercise without the dummy field
            
            let newExercise = TrackedExercise(setNumber: setNumber, id: newId, exerciseName: exerciseName, reps: reps, weight: weight, comments: comments)
            
            let database = Firestore.firestore()

            
            //print(setNumber, "  aaa")
            //push new exercise to Firestore
            let referencePush = database.collection("users").document(uId).collection(dateString).document(self.exerciseName).collection("sets").document(String(setNumber))
            referencePush.setData(newExercise.asDictionary())
            
            if setNumber == 1 {
                
                let referenceDummy = database.collection("users").document(uId).collection(exerciseName)

                referenceDummy.document(dateString).getDocument { [weak self] (snapshot, error) in
                    guard let self = self else { return }

                    if let error = error {
                        print("Error getting document: \(error.localizedDescription)")
                        return
                    }

                    // if document doesn't exist or is empty, add dummy data
                    if snapshot == nil || !snapshot!.exists {
                        referenceDummy.document(dateString).setData(["dummy": "dummy"]) { error in
                            if let error = error {
                                print("Error adding dummy data: \(error.localizedDescription)")
                            } else {
                                print("Dummy data added successfully")
                                // continue with creating the new exercise after adding dummy data
                                let repMax = self.calculateRepMax(weight: self.weight, reps: self.reps)
                                
                                let database = Firestore.firestore()
                                
                                let referenceOneRM = database.collection("users").document(uId).collection(self.exerciseName).document(dateString).collection("oneRepMax").document(String(repMax ?? 0))
                                let info: [String: Any] = ["oneRepMax": repMax ?? 0]
                                
                                referenceOneRM.setData(info) { error in
                                    if let error = error {
                                        print("Error writing document: \(error)")
                                    } else {
                                        print("Document successfully written!")
                                    }
                                }
                            }
                        }
                    } else {
                        //if document exists, continue with creating the new exercise
                        let repMax = calculateRepMax(weight: weight, reps: reps)
                        
                        let database = Firestore.firestore()
                        
                        let referenceOneRM = database.collection("users").document(uId).collection(exerciseName).document(dateString).collection("oneRepMax").document(String(repMax ?? 0))
                        let info: [String: Any] = ["oneRepMax": repMax ?? 0]
                        
                        referenceOneRM.setData(info) { error in
                            if let error = error {
                                print("Error writing document: \(error)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    }
                }
                
                
                
                
            }
        }
    }

    func calculateRepMax(weight: String, reps: String) -> Double? {
        guard Double(reps) ?? 0 > 0 else {
                return nil // Return nil if reps is not a positive number
            }
            
            let repMax = (Double(weight) ?? 0) / (1.0278 - 0.0278 * (Double(reps) ?? 0))
            return repMax
        }
    
    
    func getMaxSetNumber(uId: String, dateString: String, completion: @escaping (Int) -> Void) {
        let database = Firestore.firestore()
        let reference = database.collection("users").document(uId).collection(dateString).document(exerciseName).collection("sets")

        reference.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                completion(-1) // error case
            } else {
                var maxSetNumber = 0

                for document in querySnapshot!.documents {
                    if let documentID = Int(document.documentID) {
                        if documentID > maxSetNumber {
                            maxSetNumber = documentID
                        }
                    }
                }
                completion(maxSetNumber) // pass the maxSetNumber to the completion handler
            }
        }
    }

    
    
    
    
   var canCreate: Bool { //computed property -> yes or no (t/f)
       guard !reps.trimmingCharacters(in: .whitespaces).isEmpty else { //guard faster than if so better
           return false
       }
       guard !weight.trimmingCharacters(in: .whitespaces).isEmpty else { //guard faster than if so better
           return false
       }
       
       return true
   }
    
    
    
    
}
