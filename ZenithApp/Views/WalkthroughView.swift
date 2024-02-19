//
//  WalkthroughView.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-01-27.
//

import SwiftUI

struct WalkthroughView: View {
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("BackgroundTutorial")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack{
                    Text("Tutorials for exercises")
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                        .offset(y:10)
                    List {
                        // Upper Body Section
                        Section(header: Text("Upper Body exercises").font(.title3).bold()) {
                            ForEach(exerciseData.upperBodyexercises) { exercise in
                                NavigationLink(destination: exerciseDetailView(exercise: exercise)) {
                                    Text(exercise.name)
                                }
                            }
                            .listRowBackground(
                                        Capsule()
                                            .fill(Color("Colour3"))
                                            .padding(2)
                                    )
                        }
                        

                        // Lower Body Section
                        Section(header: Text("Lower Body exercises").font(.title3).bold()) {
                            ForEach(exerciseData.lowerBodyexercises) { exercise in
                                NavigationLink(destination: exerciseDetailView(exercise: exercise)) {
                                    Text(exercise.name)
                                }
                            }
                            .listRowBackground(
                                        Capsule()
                                            .fill(Color("Colour3"))
                                            .padding(2)
                                    )
                        }
                    }
                    .foregroundColor(.white)
                    //.navigationTitle("exercise List")
                    .padding(.horizontal, 40)
                    .scrollContentBackground(.hidden)
                    .environment(\.defaultMinListRowHeight, 60)
                }
            }
        }
    }
}


struct exerciseDetailView: View {
    var exercise: exercise

    var body: some View {
        ZStack {
            Image("BackgroundTemp")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Image(exercise.name)
                    .resizable()
                    .frame(width: 250, height: 250)
                    .cornerRadius(5)
                    .shadow(color: .black, radius: 10)
                Text(exercise.name)
                    .font(.title)
                    .foregroundColor(.white)

                Text("Instructions:")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                
                Text(exercise.instructions)
                    .foregroundColor(.white)
                    .padding()
            }
            .navigationTitle(exercise.name)
            .padding(.horizontal, 40)
        }
    }
}




#Preview {
    WalkthroughView()
}
