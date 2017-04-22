//
//  NewsViewController.swift
//  ClassRob
//
//  Created by lcdtyph on 3/16/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, XMLParserDelegate {

    var news = [News]()
    var takeTitle = false
    var takeURL = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // let url = "http://www.jwc.sjtu.edu.cn/rss/rss_notice.aspx?SubjectID=198015&TemplateID=221009"

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = "http://www.lcdtyph.com.cn/xrss.xml"
        let parser = XMLParser(contentsOf: URL(string: url)!)
        parser?.delegate = self
        parser?.parse()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        tableView.reloadData()
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
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            fatalError("cell error")
        }

        // Configure the cell...
        cell.newsTitle.text = news[indexPath.row].title
        // cell.url = news[index.Path].url

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
        super.prepare(for: segue, sender: sender)
        if segue.identifier != "LoadNews" { return }

        let nextPage = segue.destination as! WebViewController
        let selectedIndex = tableView.indexPathForSelectedRow!
        nextPage.news = news[selectedIndex.row]
    }

    var newTitle: String!
    var newURL: String?

    public func parser(_ parser: XMLParser, didStartElement elementName: String,
                       namespaceURI: String?, qualifiedName qName: String?,
                       attributes attributeDict: [String : String] = [:]) {

        switch elementName {

        case "item":
            takeTitle = false
            takeURL = false

        case "title":
            takeTitle = true

        case "link":
            takeURL = true

        default: break
        }
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String,
                       namespaceURI: String?, qualifiedName qName: String?) {

        switch elementName {

        case "item":
            takeTitle = false
            takeURL = false
            news.append(News(title: newTitle, url: newURL)!)

        case "title":
            takeTitle = false

        case "link":
            takeURL = false

        default: break
        }
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if takeTitle {
            newTitle = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        if takeURL {
            newURL = string
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }

}
