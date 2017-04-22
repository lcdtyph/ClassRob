//
//  CourseDetailController.swift
//  ClassRob
//
//  Created by lcdtyph on 4/19/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit
import FMDB

class CourseDetailController: UIViewController {

    var detail: CourseDetail!
    var database: FMDatabase? = nil

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var mark: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weeks: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.name.text      = detail.name
        self.id.text        = detail.id
        self.teacher.text   = detail.teacher
        self.mark.text      = detail.mark
        self.location.text  = detail.location
        self.time.text      = detail.time
        self.weeks.text     = detail.weeks

        favButton.addTarget(self, action: #selector(CourseDetailController.favButtonTapped(button:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initDatabase()

        if detail.favorite == -1 {
            detail.favorite = 0
            var sqlQuery = "select Cnumber from favorite where 1 = 1"
            sqlQuery += " and Cnumber = '\(detail.id)'"
            sqlQuery += " and Cteacher = '\(detail.teacher)'"
            sqlQuery += " and Cname = '\(detail.name)'"
            sqlQuery += " and Cweeks = '\(detail.weeks)'"
            sqlQuery += " and Ctime_start = '\(detail.raw_values[0])'"
            sqlQuery += " and Ctime_end = '\(detail.raw_values[1])'"
            sqlQuery += " and Cday = '\(detail.raw_values[2])'"
            sqlQuery += " and Croom = '\(detail.raw_values[3])'"
            sqlQuery += " and Clocation = '\(detail.raw_values[4])'"

            print(sqlQuery)
            do {
                let result = (try database?.executeQuery(sqlQuery, values: nil))!
                if result.next() {
                    detail.favorite = 1
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        if detail.favorite == 1 {
            favButton.isSelected = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func favButtonTapped(button: UIButton) {
        var newstat = detail.favorite == 1 ? 0 : 1

        do {
            if newstat == 1 {
                var sqlQuery = "insert into favorite(Cnumber, Cteacher, Cname, Cweeks, "
                sqlQuery += "Ctime_start, Ctime_end, Cday, Croom, Clocation)"
                sqlQuery += "values('\(detail.id)', '\(detail.teacher)', '\(detail.name)', '\(detail.weeks)', "
                sqlQuery += String(format: "'%@', '%@', '%@', '%@', '%@')", arguments: detail.raw_values)

                try database?.executeUpdate(sqlQuery, values: nil)
                button.isSelected = true
                print("set as favorite")
            } else {
                var sqlQuery = "delete from favorite where 1 = 1"
                sqlQuery += " and Cnumber = '\(detail.id)'"
                sqlQuery += " and Cteacher = '\(detail.teacher)'"
                sqlQuery += " and Cname = '\(detail.name)'"
                sqlQuery += " and Cweeks = '\(detail.weeks)'"
                sqlQuery += " and Ctime_start = '\(detail.raw_values[0])'"
                sqlQuery += " and Ctime_end = '\(detail.raw_values[1])'"
                sqlQuery += " and Cday = '\(detail.raw_values[2])'"
                sqlQuery += " and Croom = '\(detail.raw_values[3])'"
                sqlQuery += " and Clocation = '\(detail.raw_values[4])'"

                try database?.executeUpdate(sqlQuery, values: nil)
                button.isSelected = false
                print("cancel favorite")
            }
        } catch {
            print(error.localizedDescription)
            newstat = detail.favorite
        }
        detail.favorite = newstat
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
