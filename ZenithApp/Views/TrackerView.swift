//
//  TrackerView.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-01-27.
//

import SwiftUI

struct TrackerView: View {
    @StateObject var TrackerVM = TrackerViewViewModel()

    @State var searchText = "" //creating a variable to see what the user is typing
    @State private var currentDate = Date()
    @State private var isDatePickerVisible = false
    
    
    private var dateFormatter: DateFormatter = { //for printing date
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()
    

    var body: some View {
        
        
        NavigationStack {
            ZStack {
                Color("Colour4")
                    .ignoresSafeArea()
                Rectangle()
                    .frame(width: 500, height: 220)
                    .foregroundColor(Color("Colour2"))
                    .cornerRadius(10)
                    .offset(y: -400)
                
                VStack {
                    HStack {
                        Button {
                            //logic to make date go back by one day
                            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate) ?? self.currentDate
                            TrackerVM.fetchExercises(date: currentDate)
                            print(TrackerVM.exercises)
                        } label: {
                            Image(systemName: "arrowtriangle.backward.fill")
                                .foregroundColor(.white)
                                .scaleEffect(1.5)
                                .padding(5)
                        }
                        
                        Button {
                            //logic
                            self.isDatePickerVisible.toggle()
                        } label: {
                            
                            Text("\(currentDate, formatter: dateFormatter)") //https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates
                                .foregroundColor(.white)
                                .font(.title)
                        }
                        
                        Button {
                            //logic to make date go forward by one day
                            self.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate) ?? self.currentDate
                            TrackerVM.fetchExercises(date: currentDate)
                            print(TrackerVM.exercises)
                        } label: {
                            Image(systemName: "arrowtriangle.forward.fill")
                                .foregroundColor(.white)
                                .scaleEffect(1.5)
                                .padding(5)
                        }
                        
                    }
                    
                    HStack {
                        Text("Track your workout")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                        Button(action: {
                            //no action needed
                        }, label: {
                            NavigationLink(destination: LogItemView(currentDate: currentDate).searchable(text: $searchText, prompt: "Type in an exercise: ").foregroundColor(.white)) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 45, height: 45)
                             }
                        })
                        
                    }
                    .offset(y: -5)
                    .onAppear {
                        TrackerVM.fetchExercises(date: currentDate)
                        print(TrackerVM.exercises)
                    }
                    
                    List {
                        //grouping the exercises so that its separated based on name of exercise
                        let groupedExercises = Dictionary(grouping: TrackerVM.exercises, by: { $0.exerciseName })

                        ForEach(groupedExercises.sorted(by: { $0.key < $1.key }), id: \.key) { exerciseName, exercises in
                            Section(header: Text(exerciseName).font(.system(size: 25)).bold().foregroundColor(.white)) {
                                ForEach(exercises, id: \.id) { exercise in
                                    ExerciseRow(exercise: exercise) {
                                        TrackerVM.delete(exercise: exercise, date: currentDate)
                                    }
                                    
  
                                }
                                .onDelete { indexSet in
                                    for index in indexSet {/*
                                        let exerciseToDelete = TrackerVM.exercises[index]
                                        TrackerVM.delete(exercise: exerciseToDelete, date: currentDate)
                                        TrackerVM.fetchExercises(date: currentDate)*/
                                        //print(groupedExercises.sorted(by: { $0.key < $1.key }), "aaaaaa")
                                        let exerciseNameAtIndex = groupedExercises.sorted(by: { $0.key < $1.key })[index].key
                                        //print(exerciseNameAtIndex)
                                        //print(groupedExercises.sorted(by: { $0.key < $1.key })[index])
                                                
                                        //find the corresponding exercises for the exercise name
                                        if let exercisesForName = groupedExercises[exerciseNameAtIndex] {
                                            //get the exercise at the index in the exercises for the specific name
                                            let exerciseToDelete = exercisesForName[index]
                                            
                                            //delete the exercise
                                            TrackerVM.delete(exercise: exerciseToDelete, date: currentDate)
                                            
                                            //refresh view
                                            TrackerVM.fetchExercises(date: currentDate)
                                        }
                                    }
                                }
                                
                            }
                            .listRowSeparator(.hidden)
                            
                        }
                        .listRowInsets(EdgeInsets.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                        
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 50)
                    
                    
                }
            }
        }
        
        .sheet(isPresented: $isDatePickerVisible) {
            GeometryReader { geometry in
                VStack {
                    DatePicker(selection: $currentDate, displayedComponents: .date) {
                        Text("Date")
                    }
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .onChange(of: currentDate, initial: false) {
                        // Dismiss the view when a date is selected
                        isDatePickerVisible = false
                        TrackerVM.fetchExercises(date: currentDate)
                        print(TrackerVM.exercises)
                    }
                    
                    Spacer()
                }
                .frame(height: geometry.size.height / 2)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
            }
        }
    }
}


struct ExerciseRow: View {
    @StateObject var TrackerVM = TrackerViewViewModel()
    let exercise: TrackedExercise
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer(minLength: 8)
            Text("Set \(exercise.setNumber)")
                .foregroundColor(.white)
                .bold()
                .font(.system(size: 18))
            HStack {
                Text("Weight: ")
                    .bold()
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                Text(exercise.weight)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                Text("Reps: ")
                    .bold()
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .offset(x: 15)
                Text(exercise.reps)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .offset(x: 15)
            }
            if !exercise.comments.isEmpty {
                HStack {
                    Text("Comments: ")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    Text(exercise.comments)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
            }
            Spacer(minLength: 8)
        }
        .listRowBackground(
            Color("Colour3")
                .cornerRadius(10)
                .padding(3))
        
    }
}


//multiple views in one file because of functionality of navigationstack -> can't have multiple under each other otherwise errors

//view for all the possible items
struct LogItemView: View {
    
    let exerciseNames = ["Squat", "Deadlift", "Romanian Deadlift", "Front Squat", "Sumo Deadlift", "Leg Press", "Hack Squat", "Leg Extension", "Leg Curl", "Calf Raise", "Lunges", "Step-Up", "Box Jump", "Seated Leg Press", "Goblet Squat", "Rack Pull", "Zercher Squat", "Single-Leg Romanian Deadlift", "Box Squat", "Crossover Step-Up", "Pistol Squat", "Bear Crawl", "Duck Walk", "Barbell Row", "Pull-Up", "Chin-Up", "Lat Pulldown", "T-Bar Row", "Inverted Row", "Reverse Grip Lat Pulldown", "Landmine T-Bar Row", "Dumbbell Row", "Pendlay Row", "Kroc Rows", "Good Morning", "Deadlift Variations (Deficit, Sumo, Romanian)", "Rack Pulls", "Hyperextension", "Seated Cable Row", "Reverse Pec Deck", "Dumbbell Drag", "Bench Press", "Incline Bench Press", "Dumbbell Press", "Dip", "Push-Up", "Machine Chest Press", "Pec Deck", "Chest Fly", "Decline Bench Press", "Decline Russian Twist", "Hammer Curl", "Preacher Curl", "Concentration Curl", "Reverse Curl", "Tricep Dip", "Tricep Extension", "Skull Crushers", "Close-Grip Bench Press", "Tricep Kickback", "Face Pull", "Shrug", "Upright Row", "Side Lateral Raise", "Bent-Over Lateral Raise", "Front Dumbbell Raise", "Arnold Press", "Machine Shoulder Press", "Seated Overhead Press", "Landmine Press", "Plyometric Push-Up", "Medicine Ball Slam", "Leg Raises", "Hanging Leg Raise", "Russian Twist", "Hanging Windshield Wiper", "Burpee", "Spider Curl", "Dumbbell Fly", "Pullovers", "T-Bar Row", "Cable Crunch", "Reverse Grip Bench Press", "Dumbbell Pullover", "Trap Bar Deadlift", "Sissy Squat", "Jefferson Deadlift", "Zottman Curl", "Single-Leg Press", "Hollow Body Hold", "Smith Machine Squat", "Smith Machine Bench Press", "Seated Overhead Press", "Smith Machine Reverse Lunges", "Machine Shoulder Press", "Machine Chest Press", "Bent-Over Row", "Lying Leg Curl", "Seated Leg Extension", "Seated Calf Raise", "Wrist Curl", "Farmers Walk", "Face Pull", "Bodyweight Squat", "Bosu Ball Squat", "Barbell Hip Thrust", "Reverse Hyperextension", "Front Plate Raise", "Dumbbell Step-Ups", "Spider Crawl", "Kettlebell Turkish Get-Up", "Landmine Squat", "Cable Woodchopper", "Stiff-Legged Deadlift", "Reverse Crunch", "Leg Press Calf Raise", "Seated Leg Curl", "Dumbbell Renegade Row", "Sprints", "Jumping Lunges", "Single-Arm Dumbbell Row", "Lateral Box Jump", "Machine Fly", "Kettlebell Goblet Squat", "Alternating Dumbbell Curl", "Machine Leg Press", "Dumbbell Side Lateral Raise", "Hyperextension", "Kneeling Cable Crunch", "Machine Bicep Curl", "Kettlebell Farmers Walk", "Sled Push", "Sled Pull", "Lateral Band Walk", "Rope Climb", "Bodyweight Tricep Dip", "Cable Face Pull", "Leg Press Variations (Feet High, Feet Low)", "Reverse Grip Tricep Pushdown", "Band Pull-Apart", "One-Arm Cable Lateral Raise", "Machine Lateral Raise", "Hammer Strength Machine Variations (Chest, Shoulder, Back)", "Box Squat with Bands", "Sumo Deadlift High Pull", "Lat Pulldown Variations (Wide Grip, Reverse Grip)", "Swiss Ball Plank", "Machine Preacher Curl", "Jump Squat", "Landmine Rotational Press", "Dumbbell Tricep Kickback", "Single-Leg Deadlift", "Kettlebell Windmill", "Thigh Abductor Machine", "Thigh Adductor Machine", "Cable Rope Hammer Curl", "Push Press", "Seated Machine Row", "Reverse Grip Lat Pulldown", "Barbell Wrist Curl", "Seated Calf Press Machine", "Front Squat with Chains", "Rope Tricep Pushdown", "Dumbbell Hammer Curl", "Cable Leg Kickback", "Machine Reverse Fly", "Dumbbell Front Raise", "Seated Overhead Tricep Extension", "Single-Arm Kettlebell Swing", "Cable Hip Abduction", "Cable Hip Adduction", "Lateral Medicine Ball Throw", "Prowler Sled Push", "Decline Dumbbell Bench Press", "Barbell Cuban Press", "Cable Straight Arm Pulldown", "High Cable Curl", "Behind the Neck Lat Pulldown", "Close-Grip Lat Pulldown", "Reverse Grip Seated Cable Row", "Landmine T-Bar Row", "Kettlebell Clean and Press", "Medicine Ball Wall Sit", "Band Pull-Through", "Pike Push-Up", "Face Pull with External Rotation", "Hamstring Curl Machine", "Prone Leg Curl", "One-Arm Dumbbell Preacher Curl", "Rear Delt Fly Machine", "Cable Lateral Raise", "Cable Reverse Fly", "Cable Leg Press", "Seated Calf Raise Machine", "Decline Sit-Up", "Decline Russian Twist", "Landmine Single-Leg Deadlift", "Cable Crunch with Twist", "Leg Extension Machine", "Dumbbell Shrugs", "Lateral Box Step-Ups", "Cable Curl", "Seated Leg Curl Machine", "Standing Calf Raise Machine", "Leg Press Machine Variations (Close Stance, Wide Stance)", "Kettlebell Renegade Row", "Cable Kickback", "Reverse Hyperextension Machine", "Smith Machine Calf Raise", "Incline Dumbbell Curl", "Low Cable Row", "Bosu Ball Plank", "Standing Cable Chest Press", "One-Legged Leg Press", "Kettlebell Lateral Raise", "Face Pull with Rope Attachment", "Rope Hammer Curl", "Machine Preacher Curl", "Dumbbell Skull Crushers", "Seated Dumbbell Shoulder Press", "Single-Arm Machine Chest Press", "Cable Lunge", "Incline Hammer Curl", "Seated Cable Lateral Raise"] 
    @State private var searchText = "" //creating a variable to see what the user is typing
    @State private var showAlert = false

    
    @StateObject var TrackerVM = TrackerViewViewModel()
    let currentDate: Date
    
    
    init(currentDate: Date) {
            // Set the tint color for UISearchBar
        UISearchBar.appearance().overrideUserInterfaceStyle = .dark
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.currentDate = currentDate
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return exerciseNames
        } else {
            return exerciseNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        
        
        //NavigationStack {
            
        List {
            ForEach(searchResults, id: \.self) { name in //need to fix
                
                ZStack {
                    NavigationLink(destination: PlugInValuesView(exerciseName: name, currentDate: currentDate, showAlert: $showAlert)) { EmptyView() }.opacity(0.0)
                    HStack {
                        Text(name).frame(maxWidth: .infinity, alignment: .leading) //view of individual item (name)
                        Image(systemName: "plus")
                    }
                }
                
                
            }
            .listRowBackground(
                Capsule()
                    .fill(Color("Colour3"))
                    .padding(2)
            )
            
            
            
        }
        .overlay(
            Group {
                if showAlert {
                    ZStack {
                        Rectangle()
                            .frame(width: 250, height: 120)
                            .cornerRadius(10)
                            .foregroundColor(.black.opacity(0.7))
                            .transition(.opacity)
                        Text("Exercise Tracked!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
        )
        .onChange(of: showAlert) { newValue in
            if !newValue {
                // Reset showAlert when navigating back from PlugInValuesView
                showAlert = false
            } else {
                // Schedule to reset showAlert after 10 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showAlert = false
                }
            }
        }
        
        .background(Color("Colour2"))
        .navigationTitle("Exercises")
        .foregroundColor(.white)
        .environment(\.defaultMinListRowHeight, 40)
            
            
        //}
        .scrollContentBackground(.hidden)
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode:.always),
                    prompt: "Type in an exercise: ").foregroundColor(.white)
        

        
        
        
    }
}


//view for each individual item
struct PlugInValuesView: View {

    @State var exerciseName = ""
    @State var currentDate: Date
    @Binding var showAlert: Bool
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var TrackerVM = TrackerViewViewModel()
    
    

    var body: some View {
        ZStack {
            Color("Colour2")
                .ignoresSafeArea()

            VStack {
                HStack {
                    Text(exerciseName)
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                        .padding(10)
                        .offset(y: -30)
                    Spacer()
                    Button {
                        if TrackerVM.canCreate {
                            TrackerVM.exerciseName = exerciseName
                            
                            TrackerVM.createExercise(date: currentDate)
                            
                            presentationMode.wrappedValue.dismiss()
                            showAlert = true

                        } else {
                            TrackerVM.warning = true
                        }

                        
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .padding(10)
                            .offset(y: -30)
                    }

                }

                HStack {
                    Text("Weight(lbs): ")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(10)

                    Spacer()

                    TextField("0", text: $TrackerVM.weight)
                        .frame(width: 100, height: 50)
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.trailing)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .offset(y: -20)

                HStack {
                    Text("Reps(lbs): ")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(10)

                    Spacer()

                    TextField("0", text: $TrackerVM.reps)
                        .frame(width: 100, height: 50)
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.trailing)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .offset(y: -10)

                HStack {
                    Text("Comments(Optional): ")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(10)
                    Spacer()
                }

                HStack {
                    Spacer()
                    TextField("I.e. go up in weight", text: $TrackerVM.comments)
                        .frame(width: 330, height: 50)
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.trailing)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                }
                Spacer()
/*
                Image("Motivational Message")
                    .resizable()
                    .frame(width: 350, height: 420)
                    .offset(y: -10)*/
            }
            .offset(y: 52)
        }
        .alert(isPresented: $TrackerVM.warning, content: {
            Alert(title: Text("Error"),
                  message: Text("Please fill in all forms."))
        })
        
    }
    
}




#Preview {
    TrackerView()
}

