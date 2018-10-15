//
//  Pause.swift
//  fitness-ios
//
//  Created by Philipp Matthes on 15.10.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation
import UIKit

struct ExercisePlan {
    let exercises: [Exercise]
    
    private enum CodingKeys: String, CodingKey {
        case exercises
    }
    
    static let mainPlan = ExercisePlan(exercises: [
        TimedExercise(id: nil, device: "Fahrrad", durationInSeconds: 10*60, furtherInformation: "Aufwärmung QuickStart"),
        RepeatableExercise(id: "F1", device: "Beinpresse", weight: 30, minSets: 2, maxSets: 3, minRepeats: 12, maxRepeats: 15, furtherInformation: "Einstellung auf 5"),
        RepeatableExercise(id: "F2", device: "Beinbeuger", weight: 22.5, minSets: 2, maxSets: 3, minRepeats: 12, maxRepeats: 15, furtherInformation: "Einstellung auf 0, Fußspitzen anziehen!"),
        RepeatableExercise(id: "F6", device: "Lat-Zug", weight: 30, minSets: 2, maxSets: 3, minRepeats: 12, maxRepeats: 15, furtherInformation: "Sitz: 4, Unten kurz halten, Oberkörper vor!"),
        RepeatableExercise(id: "F8", device: "Bankdrücken", weight: 30, minSets: 2, maxSets: 3, minRepeats: 12, maxRepeats: 15, furtherInformation: "Sitz: 5"),
        RepeatableExercise(id: "F16", device: "Armbeuger", weight: 22.5, minSets: 2, maxSets: 3, minRepeats: 12, maxRepeats: 15, furtherInformation: "Sitz: 7"),
        RepeatableExercise(id: "F13", device: "Armstrecker", weight: 25, minSets: 2, maxSets: 3, minRepeats: 12, maxRepeats: 15, furtherInformation: "Sitz: 5, Schultern unten lassen!"),
        RepeatableExercise(id: "F15", device: "Bandmaschine", weight: 27.5, minSets: 2, maxSets: 3, minRepeats: 15, maxRepeats: 20, furtherInformation: "Sitz: 5, Finger gerade, Unten kurz halten!"),
        RepeatableExercise(id: "F14", device: "Rückenstrecker", weight: 30, minSets: 2, maxSets: 3, minRepeats: 15, maxRepeats: 20, furtherInformation: "Pedal: 3, Polster: 5"),
        TimedExercise(id: nil, device: "Laufband", durationInSeconds: 20*60, furtherInformation: "Cool Down - Zufall/Intervall/Hügel"),
    ])
    
    func createExercisePlan() -> [ExerciseItem] {
        var items = [ExerciseItem]()
        var lastExercise: Exercise?
        for exercise in exercises {
            if let lastExercise = lastExercise {
                items.append(Transition(fromExercise: lastExercise, toExercise: exercise))
            }
            lastExercise = exercise
            items += exercise.createExerciseItems()
        }
        return items
    }
}

protocol Exercise: Codable {
    var device: String {get set}
    var id: String? {get set}
    var furtherInformation: String? {get set}
    func createExerciseItems() -> [ExerciseItem]
}

struct TimedExercise: Codable, Exercise {
    
    var id: String?
    var device: String
    let durationInSeconds: Double
    var furtherInformation: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case device
        case durationInSeconds
        case furtherInformation
    }
    
    func createExerciseItems() -> [ExerciseItem] {
        return [TimedSet(durationInSeconds: durationInSeconds, device: device, furtherInformation: furtherInformation), Pause()]
    }
    
}

struct RepeatableExercise: Codable, Exercise {
    
    var id: String?
    var device: String
    let weight: Double
    let minSets: Int
    let maxSets: Int?
    let minRepeats: Int
    let maxRepeats: Int?
    var furtherInformation: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case device
        case weight
        case minSets
        case maxSets
        case minRepeats
        case maxRepeats
        case furtherInformation
    }
    
    func createExerciseItems() -> [ExerciseItem] {
        var exerciseItems = [ExerciseItem]()
        for _ in 0..<minSets {
            exerciseItems.append(RepeatableSet(device: device, weight: weight, isExtraneous: false, minRepeats: minRepeats, maxRepeats: maxRepeats, furtherInformation: furtherInformation))
            exerciseItems.append(Pause())
        }
        if let maxSets = maxSets {
            let additionalSets = maxSets - minSets
            if (additionalSets > 0) {
                for _ in 0..<additionalSets {
                    exerciseItems.append(RepeatableSet(device: device, weight: weight, isExtraneous: true, minRepeats: minRepeats, maxRepeats: maxRepeats, furtherInformation: furtherInformation))
                    exerciseItems.append(Pause())
                }
            }
        }
        return exerciseItems
    }
    
}

protocol ExerciseItem {
    func title() -> String
    func subtitle() -> String
    func color() -> UIColor
}

protocol TimedExerciseItem: ExerciseItem {
    var durationInSeconds: Double {get set}
}

struct Pause: TimedExerciseItem {
    var durationInSeconds: Double
    
    init() {
        durationInSeconds = 45
    }
    
    func title() -> String {
        return "Pause"
    }
    
    func subtitle() -> String {
        return "\(Int(durationInSeconds)) Sekunden"
    }
    
    func color() -> UIColor {
        return Colors.colorFor(number: 0)
    }
}

struct RepeatableSet: ExerciseItem {
    let device: String
    let weight: Double
    let isExtraneous: Bool
    let minRepeats: Int
    let maxRepeats: Int?
    let furtherInformation: String?
    
    func title() -> String {
        if let maxRepeats = maxRepeats {
            return "\(device): \(minRepeats) bis \(maxRepeats) Wdh."
        } else {
            return "\(device): \(minRepeats) Wdh."
        }
    }
    
    func subtitle() -> String {
        if let furtherInformation = furtherInformation {
            return "Gewicht: \(weight) kg. Info: \(furtherInformation)"
        } else {
            return "Gewicht: \(weight) kg."
        }
    }
    
    func color() -> UIColor {
        return Colors.colorFor(number: isExtraneous ? 2 : 1)
    }
}

struct TimedSet: TimedExerciseItem {
    
    var durationInSeconds: Double
    let device: String
    let furtherInformation: String?
    
    func title() -> String {
        return "\(device): \(Int(durationInSeconds)) Sekunden"
    }
    
    func subtitle() -> String {
        if let furtherInformation = furtherInformation {
            return "Info: \(furtherInformation)"
        } else {
            return "Keine weitere Info"
        }
    }
    
    func color() -> UIColor {
        return Colors.colorFor(number: 3)
    }
    
}

struct Transition: ExerciseItem {
    let fromExercise: Exercise
    let toExercise: Exercise
    
    func title() -> String {
        return "Wechsel von \(fromExercise.device) nach \(toExercise.device)"
    }
    
    func subtitle() -> String {
        if let id = toExercise.id {
            return "Die Geräte-ID des nächsten Gerätes ist \(id). Informationen zum nächsten Gerät: \(toExercise.furtherInformation ?? "keine")"
        } else {
            return "Informationen zum nächsten Gerät: \(toExercise.furtherInformation ?? "keine")"
        }
    }
    
    func color() -> UIColor {
        return Colors.colorFor(number: 4)
    }
}
