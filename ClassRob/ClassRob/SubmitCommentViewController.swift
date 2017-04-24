//
//  SubmitCommentViewController.swift
//  ClassRob
//
//  Created by lcdtyph on 4/23/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit

class SubmitCommentViewController: UIViewController {

    // MARK:
    @IBOutlet weak var commentEditor: UITextView!
    @IBOutlet weak var rating: RatingControl!

    var detail: CourseDetail!

    @IBAction func submitCallback(_ sender: Any) {
        let comment = self.commentEditor.text!
        let length = comment.characters.count
        if rating.rating == 0 {
            let alert = UIAlertController(title: "请评分", message: "请点击星星评分", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if length > 140 {
            let alert = UIAlertController(title: "评论过长", message: "请限制在140字以内哦", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if length == 0 {
            let alert = UIAlertController(title: "评论不能为空", message: "请填写评论", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let base64 = Data(comment.utf8).base64EncodedString().replacingOccurrences(of: "+", with: "%2B")
        let url = URL(string: "http://lcdtyph.com.cn/api/comment.php?action=new&cid=\(detail.id)&cmt=\(base64)&rating=\(rating.rating)")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.commentEditor.text = ""
                    self.rating.rating = 0
                    let alert = UIAlertController(title: "成功", message: "评论成功！", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }.resume()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentEditor.layer.borderColor = UIColor.gray.cgColor
        commentEditor.layer.borderWidth = 1.0
        commentEditor.layer.cornerRadius = 2.5
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
