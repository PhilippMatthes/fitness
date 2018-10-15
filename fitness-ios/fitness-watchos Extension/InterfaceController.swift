//
//  InterfaceController.swift
//  fitness-watchos Extension
//
//  Created by Philipp Matthes on 15.10.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    var exerciseItems: [ExerciseItem]!
    
    @IBAction func restartButtonPressed() {
        exerciseItems = ExercisePlan.mainPlan.createExercisePlan()
        reloadTable()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        exerciseItems = ExercisePlan.mainPlan.createExercisePlan()
        reloadTable()
    }
    
    private func reloadTable() {
        self.table.setNumberOfRows(exerciseItems.count, withRowType: "SimpleRowController")
        for i in 0..<exerciseItems.count {
            guard let controller = table.rowController(at: i) as? SimpleRowController else {continue}
            let exercise = exerciseItems[i]
            controller.configure(forExerciseItem: exercise, row: i)
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        table.removeRows(at: [rowIndex])
        exerciseItems.remove(at: 0)
        if exerciseItems.count > 0 {
            guard let controller = table.rowController(at: 0) as? SimpleRowController else {return}
            let exercise = exerciseItems[0]
            controller.configure(forExerciseItem: exercise, row: 0)
        }
    }
    
}
