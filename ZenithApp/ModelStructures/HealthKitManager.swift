//
//  HealthKitManager.swift
//  ZenithApp
//
//  Created by Lucas Jin on 2024-07-23.
//

import Foundation
import HealthKit
import WidgetKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()

    var healthStore = HKHealthStore()

    var stepCountToday: Int = 0
    var caloriesBurnedToday: Int = 0
    
    private init() {
        requestAuthorization()
    }

    func requestAuthorization() {
        //user data is available
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available!")
            return
        }

        //type of data
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ])

        //asking for user permission
        healthStore.requestAuthorization(toShare: nil, read: toReads) { success, error in
            if success {
                print("Succesful")
                self.fetchAllDatas() //fetch data if succesful
            } else {
                print("\(String(describing: error))") //print error if authorization fails
            }
        }
    }
    
    func fetchAllDatas() {
        readStepCountToday() //fetch step count for today
        readCaloriesBurnedToday() //fetch calories for today
    }

    func readStepCountToday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return //return if step count type is unavailable
        }

        let now = Date() //get current date and time
        let startDate = Calendar.current.startOfDay(for: now) //get start of today
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        ) //create predicate to query samples from start of today to now

        //query the information
        let query = HKStatisticsQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")") //print error if query fails
                return
            }

            let steps = Int(sum.doubleValue(for: HKUnit.count())) //convert the result to steps
            DispatchQueue.main.async {
                self.stepCountToday = steps //update step count on main thread
            }
        }
        healthStore.execute(query) //execute the query
    }
    
    func readCaloriesBurnedToday() {
        guard let caloriesBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }

        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: caloriesBurnedType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                //print error if query fails
                print("Failed to read calories burned: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }

            let calories = Int(sum.doubleValue(for: HKUnit.kilocalorie())) //convert to calories
            DispatchQueue.main.async {
                self.caloriesBurnedToday = calories //update calories
            }
        }
        healthStore.execute(query)
    }
    
}
