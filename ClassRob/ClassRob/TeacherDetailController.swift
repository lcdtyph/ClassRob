//
//  TeacherDetailController.swift
//  ClassRob
//
//  Created by lcdtyph on 4/23/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit
import FMDB

class TeacherDetailController: UIViewController {

    var database: FMDatabase? = nil

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var titleOfTeacher: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var office: UILabel!
    @IBOutlet weak var email: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        initDatabase()
        // Do any additional setup after loading the view.

        name.text = title
        do {
            let sqlQuery = "select * from teacher_info where Tname = '\(name.text ?? "")'"
            let result = (try database?.executeQuery(sqlQuery, values: nil))!

            if result.next() {
                school.text         = result.string(forColumn: "Tdepartment")
                titleOfTeacher.text = result.string(forColumn: "Ttitle")
                phone.text          = result.string(forColumn: "Tphone")
                office.text         = result.string(forColumn: "Taddress")
                email.text          = result.string(forColumn: "Tmail")
            }
        } catch {
            print(error.localizedDescription)
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
    
    func initDatabase() {
        if (self.database != nil) {
            return
        }

        let filePath = Bundle.main.path(forResource: "course", ofType: "db")
        print(filePath ?? "not found")

        self.database = FMDatabase(path: filePath)!

        if !((self.database?.open())!) {
            fatalError("database open failed")
        }
    }

    func closeDatabase() {
        self.database?.close()
        self.database = nil
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)

        let days = ["未指定", "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        let sqlQuery = "select a.*, b.Cday, b.Ctime_start, b.Ctime_end, b.Croom, b.Cweeks " +
            "from course_info as a natural join course_schedule as b where b.Cteacher = '\(name.text ?? "")'"

        do {
            let result = (try database?.executeQuery(sqlQuery, values: nil))!
            let nextPage = segue.destination as! UINavigationController
            let listPage = nextPage.viewControllers.first as! CourseListViewController
            listPage.title = "开设课程"
            while result.next() {
                let id = result.string(forColumn: "Cnumber")!
                let name = result.string(forColumn: "Cname")!
                let teacher = result.string(forColumn: "Cteacher")!
                let start = result.string(forColumn: "Ctime_start")!
                let end = result.string(forColumn: "Ctime_end")!
                let day = result.string(forColumn: "Cday")!
                let room = result.string(forColumn: "Croom")!
                let weeks = result.string(forColumn: "Cweeks")!
                let mark = result.string(forColumn: "Cmark")!
                let location = result.string(forColumn: "Clocation")!

                let tmpDetail = CourseDetail(name, teacher, id, mark,
                                             location + " " + room,
                                             days[Int(day)! + 1] +
                                                String(format: "第%@节-第%@节", start, end),
                                             weeks
                )
                tmpDetail.raw_values = [start, end, day, room, location]
                listPage.listItem.append(tmpDetail)
            }
        } catch {
            print(error.localizedDescription)
        }


    }

}
