//
//  DetailViewContoller.swift
//  FriendsApp
//
//  Created by Jiyoon on 2017. 10. 31..
//  Copyright © 2017년 Jiyoon. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var addButton: UIBarButtonItem = UIBarButtonItem()
    
    var first_nameVal: String = ""
    var last_nameVal: String = ""
    var genderVal: String = ""
    var emailVal: String = ""
    var phoneVal: String = ""
    var locationVal: String = ""
    var imageVal: UIImage? = nil
    
    var alreadyBestFriendList: [PersonInfo] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationBar.title = self.genderVal + "." + self.last_nameVal
        
        self.name.text = self.genderVal + "." + self.first_nameVal + " " + self.last_nameVal
        self.email.text = self.emailVal
        self.phone.text = self.phoneVal
        self.location.text = self.locationVal
        self.image.image = self.imageVal
        
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
                
                self.alreadyBestFriendList.append(person)
            }
        } catch {
            print("Failed")
        }
        
        self.addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBestFriend))
        
        self.navigationBar.rightBarButtonItem = self.addButton
        if self.alreadyBestFriendList.contains(where: { $0.email == emailVal }) {
            if self.alreadyBestFriendList.contains(where: { $0.phone == phoneVal }) {
                let removeButton: UIBarButtonItem = UIBarButtonItem(title: "Remove", style: .done, target: self, action: #selector(removeBestFriend))
                self.navigationBar.rightBarButtonItem = removeButton
            }
        }
    }
    
    @IBAction func searchOnWeb(_ sender: Any) {
        self.performSegue(withIdentifier: "showWebView", sender: nil)
    }
    
    @objc func addBestFriend() {
        let context = self.appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FriendProfile", in: context)
        
        let bestFriend = NSManagedObject(entity: entity!, insertInto: context)
        bestFriend.setValue(first_nameVal, forKey: "first_name")
        bestFriend.setValue(last_nameVal, forKey: "last_name")
        bestFriend.setValue(genderVal, forKey: "gender")
        bestFriend.setValue(emailVal, forKey: "email")
        bestFriend.setValue(phoneVal, forKey: "phone")
        bestFriend.setValue(locationVal, forKey: "location")
        let img = UIImagePNGRepresentation(imageVal!) as NSData?
        bestFriend.setValue(img, forKey: "photo")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        let person = PersonInfo(
            first_name: first_nameVal,
            last_name:last_nameVal,
            gender: genderVal,
            email: emailVal,
            phone: phoneVal,
            location: locationVal,
            photo: imageVal!
        )
        self.alreadyBestFriendList.append(person)
        let removeButton: UIBarButtonItem = UIBarButtonItem(title: "Remove", style: .done, target: self, action: #selector(removeBestFriend))
        self.navigationBar.rightBarButtonItem = removeButton
    }
    
    @objc func removeBestFriend() {
        if self.alreadyBestFriendList.contains(where: { $0.email == emailVal }) {
            if self.alreadyBestFriendList.contains(where: { $0.phone == phoneVal }) {
                let context = self.appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendProfile")
                let pred = NSPredicate(format: "(email = %@) AND (phone = %@)", self.emailVal, self.phoneVal)
                request.predicate = pred
                
                do {
                    let result = try context.fetch(request) as! [NSManagedObject]
                    
                    for data in result {
                        context.delete(data)
                    }
                    
                    do {
                        try context.save()
                    } catch {
                        print("Failed saving")
                    }
                } catch {
                    print("Failed")
                }
                
            }
        }
        
        self.navigationBar.rightBarButtonItem = self.addButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newView = segue.destination as! SearchViewController
        newView.searchKeyword = location.text! as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
