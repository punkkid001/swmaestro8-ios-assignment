//
//  SearchViewController.swift
//  FriendsApp
//
//  Created by Jiyoon on 2017. 11. 1..
//  Copyright © 2017년 Jiyoon. All rights reserved.
//

import UIKit
import WebKit

class SearchViewController: UIViewController, WKUIDelegate {
    
    var searchKeyword: String = ""
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func backward(_ sender: Any) {
        self.webView.goBack()
    }
    
    @IBAction func stopLoading(_ sender: Any) {
        self.webView.stopLoading()
    }
    
    @IBAction func reload(_ sender: Any) {
        self.webView.reload()
    }
    
    @IBAction func forward(_ sender: Any) {
        self.webView.goForward()
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let requestUrl = "https://www.google.com/search?q=" + searchKeyword
        let encodedUrl = requestUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let searchUrl = URL(string: encodedUrl)!
        
        let request = URLRequest(url: searchUrl)
        webView.load(request)
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
