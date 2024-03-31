//
//  ProfileView.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-01-27.
//

import SwiftUI
import Charts //https://www.swiftyplace.com/blog/swiftcharts-create-charts-and-graphs-in-swiftui
import SwiftUICharts

struct ProfileView: View {
    @State var exerciseNames = ["Squat", "Deadlift", "Romanian Deadlift", "Front Squat", "Sumo Deadlift", "Leg Press", "Hack Squat", "Leg Extension", "Leg Curl", "Calf Raise", "Lunges", "Step-Up", "Box Jump", "Seated Leg Press", "Goblet Squat", "Rack Pull", "Zercher Squat", "Single-Leg Romanian Deadlift", "Box Squat", "Crossover Step-Up", "Pistol Squat", "Bear Crawl", "Duck Walk", "Barbell Row", "Pull-Up", "Chin-Up", "Lat Pulldown", "T-Bar Row", "Inverted Row", "Reverse Grip Lat Pulldown", "Landmine T-Bar Row", "Dumbbell Row", "Pendlay Row", "Kroc Rows", "Good Morning", "Deadlift Variations (Deficit, Sumo, Romanian)", "Rack Pulls", "Hyperextension", "Seated Cable Row", "Reverse Pec Deck", "Dumbbell Drag", "Bench Press", "Incline Bench Press", "Dumbbell Press", "Dip", "Push-Up", "Machine Chest Press", "Pec Deck", "Chest Fly", "Decline Bench Press", "Decline Russian Twist", "Hammer Curl", "Preacher Curl", "Concentration Curl", "Reverse Curl", "Tricep Dip", "Tricep Extension", "Skull Crushers", "Close-Grip Bench Press", "Tricep Kickback", "Face Pull", "Shrug", "Upright Row", "Side Lateral Raise", "Bent-Over Lateral Raise", "Front Dumbbell Raise", "Arnold Press", "Machine Shoulder Press", "Seated Overhead Press", "Landmine Press", "Plyometric Push-Up", "Medicine Ball Slam", "Leg Raises", "Hanging Leg Raise", "Russian Twist", "Hanging Windshield Wiper", "Burpee", "Spider Curl", "Dumbbell Fly", "Pullovers", "T-Bar Row", "Cable Crunch", "Reverse Grip Bench Press", "Dumbbell Pullover", "Trap Bar Deadlift", "Sissy Squat", "Jefferson Deadlift", "Zottman Curl", "Single-Leg Press", "Hollow Body Hold", "Smith Machine Squat", "Smith Machine Bench Press", "Seated Overhead Press", "Smith Machine Reverse Lunges", "Machine Shoulder Press", "Machine Chest Press", "Bent-Over Row", "Lying Leg Curl", "Seated Leg Extension", "Seated Calf Raise", "Wrist Curl", "Farmers Walk", "Face Pull", "Bodyweight Squat", "Bosu Ball Squat", "Barbell Hip Thrust", "Reverse Hyperextension", "Front Plate Raise", "Dumbbell Step-Ups", "Spider Crawl", "Kettlebell Turkish Get-Up", "Landmine Squat", "Cable Woodchopper", "Stiff-Legged Deadlift", "Reverse Crunch", "Leg Press Calf Raise", "Seated Leg Curl", "Dumbbell Renegade Row", "Sprints", "Jumping Lunges", "Single-Arm Dumbbell Row", "Lateral Box Jump", "Machine Fly", "Kettlebell Goblet Squat", "Alternating Dumbbell Curl", "Machine Leg Press", "Dumbbell Side Lateral Raise", "Hyperextension", "Kneeling Cable Crunch", "Machine Bicep Curl", "Kettlebell Farmers Walk", "Sled Push", "Sled Pull", "Lateral Band Walk", "Rope Climb", "Bodyweight Tricep Dip", "Cable Face Pull", "Leg Press Variations (Feet High, Feet Low)", "Reverse Grip Tricep Pushdown", "Band Pull-Apart", "One-Arm Cable Lateral Raise", "Machine Lateral Raise", "Hammer Strength Machine Variations (Chest, Shoulder, Back)", "Box Squat with Bands", "Sumo Deadlift High Pull", "Lat Pulldown Variations (Wide Grip, Reverse Grip)", "Swiss Ball Plank", "Machine Preacher Curl", "Jump Squat", "Landmine Rotational Press", "Dumbbell Tricep Kickback", "Single-Leg Deadlift", "Kettlebell Windmill", "Thigh Abductor Machine", "Thigh Adductor Machine", "Cable Rope Hammer Curl", "Push Press", "Seated Machine Row", "Reverse Grip Lat Pulldown", "Barbell Wrist Curl", "Seated Calf Press Machine", "Front Squat with Chains", "Rope Tricep Pushdown", "Dumbbell Hammer Curl", "Cable Leg Kickback", "Machine Reverse Fly", "Dumbbell Front Raise", "Seated Overhead Tricep Extension", "Single-Arm Kettlebell Swing", "Cable Hip Abduction", "Cable Hip Adduction", "Lateral Medicine Ball Throw", "Prowler Sled Push", "Decline Dumbbell Bench Press", "Barbell Cuban Press", "Cable Straight Arm Pulldown", "High Cable Curl", "Behind the Neck Lat Pulldown", "Close-Grip Lat Pulldown", "Reverse Grip Seated Cable Row", "Landmine T-Bar Row", "Kettlebell Clean and Press", "Medicine Ball Wall Sit", "Band Pull-Through", "Pike Push-Up", "Face Pull with External Rotation", "Hamstring Curl Machine", "Prone Leg Curl", "One-Arm Dumbbell Preacher Curl", "Rear Delt Fly Machine", "Cable Lateral Raise", "Cable Reverse Fly", "Cable Leg Press", "Seated Calf Raise Machine", "Decline Sit-Up", "Decline Russian Twist", "Landmine Single-Leg Deadlift", "Cable Crunch with Twist", "Leg Extension Machine", "Dumbbell Shrugs", "Lateral Box Step-Ups", "Cable Curl", "Seated Leg Curl Machine", "Standing Calf Raise Machine", "Leg Press Machine Variations (Close Stance, Wide Stance)", "Kettlebell Renegade Row", "Cable Kickback", "Reverse Hyperextension Machine", "Smith Machine Calf Raise", "Incline Dumbbell Curl", "Low Cable Row", "Bosu Ball Plank", "Standing Cable Chest Press", "One-Legged Leg Press", "Kettlebell Lateral Raise", "Face Pull with Rope Attachment", "Rope Hammer Curl", "Machine Preacher Curl", "Dumbbell Skull Crushers", "Seated Dumbbell Shoulder Press", "Single-Arm Machine Chest Press", "Cable Lunge", "Incline Hammer Curl", "Seated Cable Lateral Raise"]
    @StateObject var ProfileVM = ProfileViewViewModel()
    @State private var searchText: String = ""
     
    var body: some View {
        NavigationStack {
            ZStack {
                Image("BackgroundProfile")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                ScrollView {
                    VStack{
                        Text("Your Profile")
                            .foregroundColor(.white)
                            .font(.title3)
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 150, height: 150)
                        
                        Text(ProfileVM.name)
                            .foregroundColor(.white)
                            .font(.title)
                        

                        Text("Visualize your progress!")
                            .offset(y: 50)
                            .foregroundColor(.white)
                            .bold()
                        
                        
                        
                        ZStack {
                            
                            Rectangle()
                                .frame(width: 330, height: 240)
                                .cornerRadius(10)
                                .foregroundColor(Color("Colour3"))
                            MiniExerciseListView(searchText: $searchText, exercises: $exerciseNames)
                                    .frame(width: 300, height: 200) // Adjust size as needed
                                    .background(Color.clear)
                                    .cornerRadius(10)
                                    .padding()
                            
                        }
                        .offset(y: 50)
                        
                        Button {
                            ProfileVM.logout()
                        } label: {
                            ZStack{
                                Rectangle()
                                    .frame(width: 300, height: 50)
                                    .foregroundColor(.red)
                                    .cornerRadius(10)
                                    .shadow(color: .black, radius: 5)
                                Text("Logout")
                                    .foregroundColor(.white)
                            }
                        }
                        .offset(y: 125)
                    }
                }
            }
        }
        .onAppear(perform: {
            ProfileVM.retrieveInfo()
        })
    }
}


struct MiniExerciseListView: View {
    @Binding var searchText: String
    @Binding var exercises: [String]

    var body: some View {
        VStack {
            TextField("Search Exercises", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            List {
                ForEach(exercises.filter { $0.contains(searchText) || searchText.isEmpty }, id: \.self) { exercise in
                    NavigationLink(destination: ExerciseGraph(exercise: exercise)) {
                        Text(exercise)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}

struct ExerciseGraph: View {
    @StateObject var ProfileVM = ProfileViewViewModel()
    let exercise: String

    
    var body: some View {
        ZStack {
            Image("BackgroundTracker")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            ZStack {
                
                Chart {
                    ForEach (ProfileVM.dataPoints.reversed()) { point in
                        LineMark(x: PlottableValue.value("Date", point.date),
                                 y: PlottableValue.value("1 Rep Max", point.RM))
                        
                    }
                    .foregroundStyle(Color(.white))
                    
                    
                    
                }
                .chartXAxisLabel("Date")
                .chartYAxisLabel("1 Rep Max")
                .chartXAxis {
                    AxisMarks {
                        AxisGridLine()
                    }
                }
                .chartYScale(range: .plotDimension(padding: 20))
                .padding(80)
                .background(Color(.purple))
                
            }
            
        }
        .navigationBarTitle(Text("Exercise Graph for \(exercise)"), displayMode: .inline)
        .onAppear {
            ProfileVM.retrievePoints(exercise: exercise)
        }
    }
}



#Preview {
    ProfileView()
}
