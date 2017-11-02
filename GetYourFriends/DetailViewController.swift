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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var first_nameVal: String = ""
    var last_nameVal: String = ""
    var genderVal: String = ""
    var emailVal: String = ""
    var phoneVal: String = ""
    var locationVal: String = ""
    var imageVal: UIImage? = nil
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.name.text = self.genderVal + "." + self.first_nameVal + " " + self.last_nameVal
        self.email.text = self.emailVal
        self.phone.text = self.phoneVal
        self.location.text = self.locationVal
        self.image.image = self.imageVal
    }
    
    @IBAction func searchOnWeb(_ sender: Any) {
        self.performSegue(withIdentifier: "showWebView", sender: nil)
    }
    
    @IBAction func addBestFriend(_ sender: Any) {
        //print("hello")
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

