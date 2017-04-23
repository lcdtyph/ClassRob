//
//  CommentViewController.swift
//  ClassRob
//
//  Created by lcdtyph on 4/23/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!

    var detail: CourseDetail!

    @IBAction func indexChanged(_ sender: Any) {
        let sc = sender as! UISegmentedControl

        switch sc.selectedSegmentIndex {

        case 0:
            firstView.isHidden = false
            secondView.isHidden = true

        case 1:
            firstView.isHidden = true
            secondView.isHidden = false
            let secondVC = childViewControllers[1] as! LoadCommentViewController
            secondVC.loadComment()

        default:
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstView.isHidden = false
        secondView.isHidden = true
        let firstVC = childViewControllers[0] as! SubmitCommentViewController
        firstVC.detail = detail
        let secondVC = childViewControllers[1] as! LoadCommentViewController
        secondVC.detail = detail

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
        if segue.identifier == "SubmitSegue" {
            let vc = segue.destination as! SubmitCommentViewController
            vc.detail = self.detail
        } else if segue.identifier == "LoadSegue" {
            let vc = segue.destination as! LoadCommentViewController
            vc.detail = self.detail
        }
    }
    */

}
