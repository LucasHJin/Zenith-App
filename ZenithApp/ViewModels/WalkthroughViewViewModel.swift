//
//  WalkthroughViewViewModel.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-02-04.
//

import Foundation

struct exercise: Identifiable { //individual exercises + details
    let id = UUID()
    let name: String
    let instructions: String
}


// exerciseData struct with separate arrays for upper body and lower body exercises
struct exerciseData {
    static var upperBodyexercises = [
        exercise(name: "Bench Press", instructions: "Muscle Worked: Chest\n1. Lie down on a flat bench with your back and shoulders firmly pressed against it.\n2. Grip the barbell with hands slightly wider than shoulder-width apart.\n3. Lower the barbell to your chest in a controlled manner.\n4. Push the barbell back up to the starting position."),
        
        exercise(name: "Pull-up", instructions: "Muscle Worked: Back\n1. Hang from a pull-up bar with palms facing away.\n2. Pull your body upward until your chin passes the bar.\n3. Lower your body back down with control.\n4. Repeat for the desired number of repetitions."),
        
        exercise(name: "Overhead Press", instructions: "Muscle Worked: Shoulders\n1. Stand with feet shoulder-width apart.\n2. Hold a barbell at shoulder height with palms facing forward.\n3. Press the barbell overhead until your arms are fully extended.\n4. Lower the barbell back to shoulder height."),

        exercise(name: "Bicep Curl", instructions: "Muscle Worked: Biceps\n1. Stand with a dumbbell in each hand, palms facing forward.\n2. Curl the dumbbells toward your shoulders, keeping your elbows close to your body.\n3. Lower the dumbbells back down with control."),
        
        exercise(name: "Tricep Dip", instructions: "Muscle Worked: Triceps\n1. Position your hands shoulder-width apart on parallel bars or sturdy surfaces.\n2. Lower your body by bending your elbows until your upper arms are parallel to the ground.\n3. Push your body back up to the starting position.")
    ]

    static var lowerBodyexercises = [
        exercise(name: "Squat", instructions: "Muscle Worked: Quadriceps\n1. Stand with your feet shoulder-width apart.\n2. Bend your knees and lower your body as if you are sitting back into a chair.\n3. Keep your back straight and chest up as you squat down.\n4. Stand back up to the starting position."),
        
        exercise(name: "Hamstring Curls", instructions: "Muscle Worked: Hamstrings\n1. Lie face down on a leg curl machine with your heels against the pad.\n2. Curl your heels up toward your buttocks by bending your knees.\n3. Lower the pad back down in a controlled manner."),

        exercise(name: "Abductor Machine", instructions: "Muscle Worked: Abductors\n1. Sit on the abductor machine with your back against the backrest.\n2. Place your legs on the machine's pads.\n3. Push the pads outward, away from your body, as far as comfortable.\n4. Bring the pads back to the starting position with control."),
        
        exercise(name: "Leg Extensions", instructions: "Muscle Worked: Quadriceps\n1. Sit on the leg extension machine with your back against the backrest.\n2. Place your legs under the resistance pad.\n3. Extend your legs forward, lifting the resistance pad.\n4. Lower the resistance pad back to the starting position with control."),
        
        exercise(name: "Calf Raise", instructions: "Muscle Worked: Calves\n1. Stand with your feet hip-width apart.\n2. Lift your heels off the ground by pushing through the balls of your feet.\n3. Lower your heels back down in a controlled manner.")
    ]
}
