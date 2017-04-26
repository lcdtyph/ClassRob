//
//  CourseDetailController.swift
//  ClassRob
//
//  Created by lcdtyph on 4/19/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit
import FMDB

class CourseDetailController: UIViewController{

    var detail: CourseDetail!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var mark: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weeks: UILabel!

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

        if detail.favorite == -1 {
            detail.updateFavorite()
        }
        if detail.favorite == 1 {
            favButton.isSelected = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let newstat = detail.favorite == 1 ? 0 : 1

        detail.favorite = newstat
        button.isSelected = newstat == 1
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowTeacherSegue" {
            let nextPage = segue.destination as! TeacherDetailController
            nextPage.title = detail.teacher
        } else if segue.identifier == "CommentSegue" {
            let nextPage = segue.destination as! CommentViewController
            nextPage.detail = detail
        }
    }

}
