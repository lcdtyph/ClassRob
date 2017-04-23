//
//  CourseDetailController.swift
//  ClassRob
//
//  Created by lcdtyph on 4/19/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit
import FMDB

class CourseDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var detail: CourseDetail!
    var database: FMDatabase? = nil
    var editStackDet: CGFloat = 0
    var commentData = [Any]()

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var mark: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weeks: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editStack: UIStackView!

    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentEditor: UITextView!

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

        editStackDet = view.frame.height - editStack.frame.origin.y
        commentEditor.layer.borderColor = UIColor.gray.cgColor
        commentEditor.layer.borderWidth = 1.0
        commentEditor.layer.cornerRadius = 2.5
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        favButton.addTarget(self, action: #selector(CourseDetailController.favButtonTapped(button:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self,
                            selector: #selector(CourseDetailController.keyboardWillShow(_: )),
                            name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                            selector: #selector(CourseDetailController.keyboardWillHide(_: )),
                            name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(_ notification: Notification) {
        adjustingHeight(show: true, notification: notification)
    }

    func keyboardWillHide(_ notification: Notification) {
        adjustingHeight(show: false, notification: notification)
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
        loadComment()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeDatabase()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func favButtonTapped(button: UIButton) {
        var newstat = detail.favorite == 1 ? 0 : 1

        do {
            if newstat == 1 {
                var sqlQuery = "insert into favorite(Cnumber, Cteacher, Cname, Cweeks, Cmark, "
                sqlQuery += "Ctime_start, Ctime_end, Cday, Croom, Clocation)"
                sqlQuery += "values('\(detail.id)', '\(detail.teacher)', '\(detail.name)', '\(detail.weeks)', '\(detail.mark)', "
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

    func adjustingHeight(show: Bool, notification: Notification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)

        let changeInHeight = keyboardFrame.origin.y
        editStack.frame.origin.y = changeInHeight - editStackDet
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        if segue.identifier != "ShowTeacherSegue" { return }
        let nextPage = segue.destination as! TeacherDetailController
        nextPage.title = detail.teacher
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            fatalError("cell error")
        }

        // Configure the cell...
        let data = commentData[indexPath.row] as! [String: String]
        cell.comment.text = data["Ccomment"]
        cell.timestamp.text = data["Timestamp"]
        // cell.url = news[index.Path].url

        return cell
    }

    func loadComment() {
        let url = URL(string: "http://lcdtyph.com.cn/api/comment.php?action=require&cid=\(detail.id)")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    self.commentData = parsedData["data"] as! [Any]

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
    }

    // ACTION:
    @IBAction func submitComment(_ sender: Any) {
        let comment = self.commentEditor.text!
        let length = comment.characters.count
        if length > 140 {
            let alert = UIAlertController(title: "评论过长", message: "请限制在140字以内哦", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let base64 = Data(comment.utf8).base64EncodedString()
        let url = URL(string: "http://lcdtyph.com.cn/api/comment.php?action=new&cid=\(detail.id)&cmt=\(base64)")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.commentEditor.text = ""
                    self.loadComment()
                }
            }
        }.resume()
    }

}
