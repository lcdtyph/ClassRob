//
//  CourseDetail.swift
//  ClassRob
//
//  Created by lcdtyph on 4/19/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import Foundation

class CourseDetail {
    init(_ name: String, _ teacher: String, _ id: String, _ mark: String,
         _ location: String, _ time: String, _ weeks: String) {
        self.name     = name
        self.teacher  = teacher
        self.id       = id
        self.mark     = mark
        self.location = location
        self.time     = time
        self.weeks    = weeks
    }

    var name:     String = "n/a"
    var teacher:  String = "n/a"
    var id:       String = "n/a"
    var mark:     String = "n/a"
    var location: String = "n/a"
    var time:     String = "n/a"
    var weeks:    String = "n/a"
    var favorite: Int    = -1
    var raw_values: [String] = []
}
