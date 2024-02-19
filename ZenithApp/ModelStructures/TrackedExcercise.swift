//
//  TrackedExercise.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-01-27.
//

import Foundation

struct TrackedExercise: Identifiable, Codable {
    var setNumber: Int
    var id: String
    var exerciseName: String
    var reps: String
    var weight: String
    var comments: String
}
