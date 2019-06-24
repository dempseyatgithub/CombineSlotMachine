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
            .map{ "\($0.0) \($0.1) \($0.2)" }
            .sink(receiveValue: { print("\($0)") })

    }


    @IBAction func spin(_ sender: UIButton) {
        firstReelValue = reelChoices.randomElement()!
        secondReelValue = reelChoices.randomElement()!
        thirdReelValue = reelChoices.randomElement()!
    }
}

