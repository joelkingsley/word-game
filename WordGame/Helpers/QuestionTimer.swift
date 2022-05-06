//
//  QuestionTimer.swift
//  WordGame
//
//  Created by Joel Kingsley on 06/05/2022.
//

import Foundation

/**
 Countdown timer for each question
 */
class QuestionTimer {
    var timer = Timer()
    
    private let timePerQuestionInSeconds = 5
    
    var remainingTime: Int
    
    let fireHandler: () -> Void
    
    init(fireHandler: @escaping () -> Void) {
        self.fireHandler = fireHandler
        self.remainingTime = timePerQuestionInSeconds
    }
    
    func start() {
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(checkRemainingTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    func stop() {
        timer.invalidate()
        remainingTime = timePerQuestionInSeconds
    }
    
    @objc func checkRemainingTime() {
        print("Question Timer has remaining time: \(remainingTime) seconds")
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            stop()
            fireHandler()
        }
    }
}
