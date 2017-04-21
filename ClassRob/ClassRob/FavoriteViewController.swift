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

class FavoriteViewController: UITableViewController {

    var favItems = [FavItem]()
    var database: FMDatabase? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initDatabase()
        loadFavItems()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        closeDatabase()
    }

    func loadFavItems() {
        do {
            let result = (try self.database?.executeQuery("select Cname,Cnumber,Cteacher from favorite", values: nil))!

            while result.next() {
                self.favItems.append(FavItem(name: result.string(forColumn: "Cname"),
                                             number: result.string(forColumn: "Cnumber"),
                                             teacher: result.string(forColumn: "Cteacher")))
            }

        } catch {
            print(error.localizedDescription)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.favItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as? FavCell else {
            fatalError()
        }

        // Configure the cell...
        cell.courseName.text = favItems[indexPath.row].name
        cell.courseNumber.text = favItems[indexPath.row].number
        cell.courseTeacher.text = favItems[indexPath.row].teacher

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


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
