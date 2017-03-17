//
//  News.swift
//  ClassRob
//
//  Created by lcdtyph on 3/16/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit

class News {

    var title: String
    var url: String?

    init?(title: String, url:String?) {
        guard !title.isEmpty else {
            return nil
        }

        self.title = title
        self.url = url
    }
}
