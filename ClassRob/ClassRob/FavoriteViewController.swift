//
//  FavoriteViewController.swift
//  ClassRob
//
//  Created by lcdtyph on 3/28/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit
import FMDB

class FavItem {
    var name: String
    var number: String
    var teacher: String

    init(name: String, number: String, teacher: String) {
        self.name = name
        self.number = number
        self.teacher = teacher
    }
}

class FavoriteViewController: UINavigationController, UINavigationControllerDelegate {

    var favItems = [FavItem]()
    var database: FMDatabase? = nil
    let days = ["未指定", "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initDatabase()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeDatabase()
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let nextVC = viewController as? CourseListViewController, nextVC === self.viewControllers.first {
            do {
                if self.database == nil {
                    initDatabase()
                }

                let result = (try self.database?.executeQuery("select * from favorite", values: nil))!

                nextVC.listItem = []
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
                    nextVC.listItem.append(tmpDetail)
                }
                nextVC.title = "我的收藏"
                nextVC.navigationItem.leftBarButtonItem = nil
                nextVC.tableView.reloadData()

            } catch {
                print(error.localizedDescription)
            }
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FavoriteSegue" {
            let nextPage = segue.destination as! CourseDetailController
            nextPage.detail = CourseDetail("a", "b", "c", "d", "e", "f", "g")
            nextPage.title = "Course Detail"
        }
    }


}
