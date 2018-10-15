//
//  SimpleRowController.swift
//  fitness-watchos Extension
//
//  Created by Philipp Matthes on 15.10.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation
import WatchKit

class SimpleRowController: NSObject {
    
    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var descriptionLabel: WKInterfaceLabel!
    @IBOutlet weak var backgroundGroup: WKInterfaceGroup!
    
    private var item: ExerciseItem!
    
    func configure(forExerciseItem item: ExerciseItem, row: Int) {
        titleLabel.setText(item.title())
        titleLabel.setTextColor(.white)
        descriptionLabel.setText(item.subtitle())
        descriptionLabel.setTextColor(.white)
        backgroundGroup.setBackgroundColor(item.color())
        if let item = item as? TimedExerciseItem, row == 0 {
            timer.setDate(Date().addingTimeInterval(item.durationInSeconds))
            timer.setHidden(false)
            timer.start()
        } else {
            timer.setHidden(true)
        }
    }
    
}
