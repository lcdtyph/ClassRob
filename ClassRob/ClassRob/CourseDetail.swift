//
//  CourseDetail.swift
//  ClassRob
//
//  Created by lcdtyph on 4/19/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import Foundation
import FMDB

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

    var database: FMDatabase? = nil

    var name:     String = "n/a"
    var teacher:  String = "n/a"
    var id:       String = "n/a"
    var mark:     String = "n/a"
    var location: String = "n/a"
    var time:     String = "n/a"
    var weeks:    String = "n/a"
    var raw_values: [String] = []

    var favorite: Int    = -1 {
        didSet {
            if favorite == -1 || oldValue == -1 { return }
            initDatabase()

            do {
                if favorite == 1 {
                    var sqlQuery = "insert into favorite(Cnumber, Cteacher, Cname, Cweeks, Cmark, "
                    sqlQuery += "Ctime_start, Ctime_end, Cday, Croom, Clocation)"
                    sqlQuery += "values('\(self.id)', '\(self.teacher)', '\(self.name)', '\(self.weeks)', '\(self.mark)', "
                    sqlQuery += String(format: "'%@', '%@', '%@', '%@', '%@')", arguments: self.raw_values)

                    try database?.executeUpdate(sqlQuery, values: nil)
                    print("set as favorite")
                } else {
                    var sqlQuery = "delete from favorite where 1 = 1"
                    sqlQuery += " and Cnumber = '\(self.id)'"
                    sqlQuery += " and Cteacher = '\(self.teacher)'"
                    sqlQuery += " and Cname = '\(self.name)'"
                    sqlQuery += " and Cweeks = '\(self.weeks)'"
                    sqlQuery += " and Ctime_start = '\(self.raw_values[0])'"
                    sqlQuery += " and Ctime_end = '\(self.raw_values[1])'"
                    sqlQuery += " and Cday = '\(self.raw_values[2])'"
                    sqlQuery += " and Croom = '\(self.raw_values[3])'"
                    sqlQuery += " and Clocation = '\(self.raw_values[4])'"

                    try database?.executeUpdate(sqlQuery, values: nil)
                    print("cancel favorite")
                }
            } catch {
                print(error.localizedDescription)
            }

            closeDatabase()
        }
    }

    func updateFavorite() {
        favorite = -1
        initDatabase()

        var sqlQuery = "select Cnumber from favorite where 1 = 1"
        sqlQuery += " and Cnumber = '\(self.id)'"
        sqlQuery += " and Cteacher = '\(self.teacher)'"
        sqlQuery += " and Cname = '\(self.name)'"
        sqlQuery += " and Cweeks = '\(self.weeks)'"
        sqlQuery += " and Ctime_start = '\(self.raw_values[0])'"
        sqlQuery += " and Ctime_end = '\(self.raw_values[1])'"
        sqlQuery += " and Cday = '\(self.raw_values[2])'"
        sqlQuery += " and Croom = '\(self.raw_values[3])'"
        sqlQuery += " and Clocation = '\(self.raw_values[4])'"

        var newstat = 0
        print(sqlQuery)
        do {
            let result = (try database?.executeQuery(sqlQuery, values: nil))!
            if result.next() {
                newstat = 1
            }
        } catch {
            print(error.localizedDescription)
        }
        favorite = newstat

        closeDatabase()
    }

    func initDatabase() {
        if (self.database != nil) {
            return
        }

        guard let documents = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true) else {
                                                            fatalError("url error")
        }
        let fileURL = documents.appendingPathComponent("fav.db")
        print(fileURL.absoluteString)

        self.database = FMDatabase(path: fileURL.path)!

        if !((self.database?.open())!) {
            fatalError("database open failed")
        }
    }

    func closeDatabase() {
        self.database?.close()
        self.database = nil
    }

}
