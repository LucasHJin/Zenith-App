//
//  Extensions.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-02-05.
//

import Foundation


//function to make it so you don't have to hardcode the dictionaries in different parameters
//converting model into dictionary that can be written into database
extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { //give me data from the current thing that is codable
            return [:]
        }
        
        //format: https://codewithchris.com/swift-try-catch/
        do {
            //convert to JSON (a dictionary) https://www.w3schools.com/js/js_json_intro.asp
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] //as? is conditional downcasting
            //downcasting = typecasting (superclass -> subclass)
            //https://www.educative.io/answers/what-is-up-and-down-casting-in-swift
            return json ?? [:] //?? is otherwise
        } catch {
            return [:]
        }
    }
}
