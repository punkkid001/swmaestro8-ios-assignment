//
//  BestFriendsController.swift
//  FriendsApp
//
//  Created by Jiyoon on 2017. 10. 28..
//  Copyright © 2017년 Jiyoon. All rights reserved.
//

import UIKit
import CoreData

class BestFriendViewController: UITableViewController {
    var selectedFriend: PersonInfo?
    var myFriendsInfo: [PersonInfo] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBestFriends()
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func saveBestFriends() {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FriendProfile", in: context)
        
        do {
            for person in self.myFriendsInfo {
                let bestFriend = NSManagedObject(entity: entity!, insertInto: context)
                
                bestFriend.setValue(person.first_name, forKey: "first_name")
                bestFriend.setValue(person.last_name, forKey: "last_name")
                bestFriend.setValue(person.gender, forKey: "gender")
                bestFriend.setValue(person.email, forKey: "email")
                bestFriend.setValue(person.phone, forKey: "phone")
                bestFriend.setValue(person.location, forKey: "location")
                let img = UIImagePNGRepresentation(person.photo!) as NSData?
                bestFriend.setValue(img, forKey: "photo")
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        }
    }
    
    func loadBestFriends() {
        self.myFriendsInfo = []
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendProfile")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let first_name = data.value(forKey: "first_name") as! String
                let last_name = data.value(forKey: "last_name") as! String
                let gender = data.value(forKey: "gender") as! String
                let location = data.value(forKey: "location") as! String
                let phone = data.value(forKey: "phone") as! String
                let email = data.value(forKey: "email") as! String
                let photo:UIImage = UIImage(data: (data.value(forKey: "photo") as! NSData) as Data)!
                
                let person: PersonInfo = PersonInfo(
                    first_name: first_name,
                    last_name: last_name,
                    gender: gender,
                    email: email,
                    phone: phone,
                    location: location,
                    photo: photo
                )
                self.myFriendsInfo.append(person)
            }
        } catch {
            print("Failed")
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadBestFriends()
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
        let rowCount: Int = self.myFriendsInfo.count
        return rowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bestfriendsCell", for: indexPath)
        
        let person = self.myFriendsInfo[indexPath.row]
        cell.textLabel!.text = person.first_name + " " + person.last_name
        cell.detailTextLabel!.text = person.email
        cell.imageView?.image = person.photo
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.myFriendsInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        /*
         else if editingStyle == .insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
         */
    }
    
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let item = self.myFriendsInfo[fromIndexPath.row]
        self.myFriendsInfo.remove(at: fromIndexPath.row)
        self.myFriendsInfo.insert(item, at: to.row)
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendProfile")
        request.returnsObjectsAsFaults = false
        do {
            let totalBestFriends = try context.fetch(request) as! [NSManagedObject]
            
            for data in totalBestFriends {
                context.delete(data)
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch {
            print("Failed")
        }
        
        self.saveBestFriends()
     }
    
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
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
