//
//  MyFriendsController.swift
//  FriendsApp
//
//  Created by Jiyoon on 2017. 10. 28..
//  Copyright © 2017년 Jiyoon. All rights reserved.
//

import UIKit
import Foundation

class MyFriendViewController: UITableViewController {
    var selectedFriend: PersonInfo?
    var refresher: UIRefreshControl!
    var myFriendsInfo: [PersonInfo] = []
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(MyFriendViewController.populate), for: .valueChanged)
        tableView.addSubview(refresher)
        
        self.myActivityIndicator.hidesWhenStopped = true
        view.addSubview(self.myActivityIndicator)
        
        let barButtonItem = UIBarButtonItem(customView: self.myActivityIndicator)
        self.navigationBar.rightBarButtonItem = barButtonItem
        
        self.getFriendsList()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func addRefreshHeader() {
        self.myActivityIndicator.startAnimating()
    }
    
    func removeRefreshHeader() {
        self.myActivityIndicator.stopAnimating()
        //self.navigationBar.rightBarButtonItem = nil
    }
    
    @objc func getFriendsList() {
        var tempFriendInfo = [PersonInfo]()
        
        let url = URL(string: "https://randomuser.me/api/?results=20&inc=name,picture,nat,cell,email,id")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                let results = jsonData["results"] as! NSArray
                
                for case let result as NSDictionary in results {
                    let name_info = result["name"] as! NSDictionary
                    let photo_info = result["picture"] as! NSDictionary
                    
                    let person: PersonInfo = PersonInfo(
                        first_name: name_info["first"] as! String,
                        last_name: name_info["last"] as! String,
                        gender: name_info["title"] as! String,
                        email: result["email"] as! String,
                        phone: result["cell"] as! String,
                        location: result["nat"] as! String,
                        photo: photo_info["medium"] as! String
                    )
                    //self.myFriendsInfo.append(person)
                    tempFriendInfo.append(person)
                }
                DispatchQueue.main.async {
                    self.myFriendsInfo = tempFriendInfo
                    self.tableView.reloadData()

                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    @objc func populate() {
        self.myFriendsInfo = []
        self.getFriendsList()
        refresher.endRefreshing()
    }
    
    @IBAction func reloadFriendList(_ sender: Any) {
        self.addRefreshHeader()
        self.myFriendsInfo = []
        self.getFriendsList()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.removeRefreshHeader()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFriendDetails" {
            let cell = sender as! UITableViewCell
            let index = tableView.indexPath(for: cell)
            if let indexPath = index?.row {
                selectedFriend = myFriendsInfo[indexPath]
            }
        }
        
        let newView = segue.destination as! DetailViewController
        newView.first_nameVal = (selectedFriend?.first_name)!
        newView.last_nameVal = (selectedFriend?.last_name)!
        newView.genderVal = (selectedFriend?.gender)!
        newView.emailVal = (selectedFriend?.email)!
        newView.locationVal = (selectedFriend?.location)!
        newView.phoneVal = (selectedFriend?.phone)!
        newView.imageVal = (selectedFriend?.photo)!
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let rowCount: Int = self.myFriendsInfo.count
        return rowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myfriendsCell", for: indexPath)
        
        if self.myFriendsInfo.count > 0 {
            let person = self.myFriendsInfo[indexPath.row]
            cell.textLabel!.text = person.first_name + " " + person.last_name
            cell.detailTextLabel!.text = person.email
            cell.imageView?.image = person.photo
        }
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

