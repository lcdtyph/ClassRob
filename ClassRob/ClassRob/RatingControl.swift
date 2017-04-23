//
//  RatingControl.swift
//  ClassRob
//
//  Created by lcdtyph on 4/24/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var rating: Int = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    func setupButtons() {
        for sv in subviews{
            let button = sv as! UIButton
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
        }
    }

    func ratingButtonTapped(button: UIButton) {
        guard let index = subviews.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(subviews)")
        }

        // Calculate the rating of the selected button
        let selectedRating = index + 1

        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }

    func updateButtonSelectionState() {
        for index in 0..<self.subviews.count {
            let btn = subviews[index] as! UIButton
            btn.isSelected = index < rating
        }
    }
}
