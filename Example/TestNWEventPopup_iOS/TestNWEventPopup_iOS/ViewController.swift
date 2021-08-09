//
//  ViewController.swift
//  TestNWEventPopup_iOS
//
//  Created by Minjun Kim on 2021/07/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchToWebView1(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewDemo") as! WebViewDemo
        nextViewController.paramUrl = "http://211.111.217.78:7070/apptest1.jsp"
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func touchToWebView2(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewDemo") as! WebViewDemo
        nextViewController.paramUrl = "http://211.111.217.78:7070/apptest2.jsp"
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func touchToNavtiveView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NativeViewDemo") as! NativeViewDemo
        self.present(nextViewController, animated:true, completion:nil)
    }
}

