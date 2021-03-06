//
//  SearchViewController.swift
//  ClassRob
//
//  Created by lcdtyph on 3/15/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit
import FMDB

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var database: FMDatabase? = nil
    let days = ["未指定", "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
    let times = ["未指定", "第1-2节", "第3-4节", "第5-6节", "第7-8节", "第9-10节", "第11-12节", "第13-14节"]
    var selectedDay: Int = 0
    var selectedTime: Int = 0

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nameKeyword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initDatabase()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        closeDatabase()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initDatabase() {
        if (self.database != nil) {
            return
        }

//        guard let documents = try? FileManager.default.url(for: .documentDirectory,
//                                                           in: .userDomainMask,
//                                                           appropriateFor: nil,
//                                                           create: true) else {
//            fatalError("url error")
//        }

        let filePath = Bundle.main.path(forResource: "course", ofType: "db")
//        let fileURL = documents.appendingPathComponent("fav.db")
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

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? days.count : times.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? days[row] : times[row];
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedDay = row
        } else if component == 1 {
            selectedTime = row
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier != "SearchSegue" { return }
        var sqlQuery: String = ""
        sqlQuery += "select a.*, b.Cday, b.Ctime_start, b.Ctime_end, b.Croom, b.Cweeks "
        sqlQuery += "from course_info as a natural join course_schedule as b where 1 = 1"

        if !(nameKeyword.text?.isEmpty)! {
            sqlQuery += " and a.Cname like '%\(nameKeyword.text ?? "")%'"
        }
        if selectedDay != 0 {
            sqlQuery += " and b.Cday = \(selectedDay - 1)"
        }
        if selectedTime != 0 {
            sqlQuery += " and b.Ctime_start <= \(selectedTime * 2 - 1)"
            sqlQuery += " and b.Ctime_end >= \(selectedTime * 2)"
        }

        do {
            let result = (try database?.executeQuery(sqlQuery, values: nil))!
            let nextPage = segue.destination as! UINavigationController
            let listPage = nextPage.viewControllers.first as! CourseListViewController
            listPage.title = "搜索结果"
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

