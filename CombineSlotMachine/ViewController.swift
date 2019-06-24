//
//  ViewController.swift
//  CombineSlotMachine
//
//  Created by James Dempsey on 6/22/19.
//  Copyright © 2019 James Dempsey. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var spinResultsLabel: UILabel!
    
    @Published var firstReelValue: String = ""
    @Published var secondReelValue: String = ""
    @Published var thirdReelValue: String = ""
    
    var reelCancellable: Cancellable!
    var scoreCancellable: Cancellable!
    
    let reelChoices = ["🍒", "🍋", "🔔", "7️⃣", "⚊", "⚌", "☰"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reelCancellable = Publishers.Zip3($firstReelValue, $secondReelValue, $thirdReelValue)
                            .map{ "\($0.0) \($0.1) \($0.2)" }
                            .assign(to: \.text, on: spinResultsLabel)
        
        scoreCancellable = Publishers.Zip3($firstReelValue, $secondReelValue, $thirdReelValue)
            .map{ self.score(for: $0) }
            .sink(receiveValue: { print("\($0)") })

    }


    @IBAction func spin(_ sender: UIButton) {
        firstReelValue = reelChoices.randomElement()!
        secondReelValue = reelChoices.randomElement()!
        thirdReelValue = reelChoices.randomElement()!
    }
    
    func score(for reels: (String, String, String)) -> Int {
        switch reels {
        case ("🍒", "🍒", "🍒"):
            return 100
        case ("7️⃣", "7️⃣", "7️⃣"):
            return 75
        case ("🔔", "🔔", "🔔"):
            return 50
        case ("☰", "☰", "☰"):
            return 50
        case ("⚌", "⚌", "⚌"):
            return 25
        case ("⚊", "⚊", "⚊"):
            return 10
        case ("🍋", "🍋", "🍋"):
            return 5
        default:
            return 0
        }
    }
}

