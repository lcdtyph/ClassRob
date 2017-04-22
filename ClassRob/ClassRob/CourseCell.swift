//
//  CourseCell.swift
//  ClassRob
//
//  Created by lcdtyph on 4/21/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {

    // MARK
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var schedule: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
