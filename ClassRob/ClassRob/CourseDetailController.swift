//
//  CourseDetailController.swift
//  ClassRob
//
//  Created by lcdtyph on 4/19/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit

class CourseDetailController: UIViewController {

    var detail: CourseDetail!

    @IBOutlet weak var name: UILabel!
    
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
        self.id.text        = detail.id;
        self.teacher.text   = detail.teacher
        self.mark.text      = detail.mark
        self.location.text  = detail.location
        self.time.text      = detail.time
        self.weeks.text     = detail.weeks
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
