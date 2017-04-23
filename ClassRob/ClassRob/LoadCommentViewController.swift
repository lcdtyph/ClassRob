//
//  LoadCommentViewController.swift
//  ClassRob
//
//  Created by lcdtyph on 4/24/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit

class LoadCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var commentData = [Any]()
    var detail: CourseDetail!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadComment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.rating.rating = Int(data["Crating"]!) ?? 0

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
