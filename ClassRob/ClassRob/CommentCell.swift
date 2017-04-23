//
//  CommentCell.swift
//  ClassRob
//
//  Created by lcdtyph on 4/23/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var timestamp: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
