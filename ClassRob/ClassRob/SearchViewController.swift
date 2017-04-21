//
//  FirstViewController.swift
//  ClassRob
//
//  Created by lcdtyph on 3/15/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit
import FMDB

class FirstViewController: UIViewController {

    var database: FMDatabase? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        initDatabase()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
}

