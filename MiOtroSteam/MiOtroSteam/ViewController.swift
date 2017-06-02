//
//  ViewController.swift
//  MiOtroSteam
//
//  Created by Thybak on 20/04/2017.
//  Copyright © 2017 etsisi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var webview: UIWebView!
    @IBOutlet var ViewProfile: UIButton!
    @IBOutlet var TxtSteamID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL (string: "http://miotrosteam.duckdns.org")
        let requestObj = NSURLRequest(url: url as! URL)
        webview.loadRequest(requestObj as URLRequest)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction
    func saveUser(){
        let defaults = UserDefaults.standard
        defaults.setValue(TxtSteamID.text!, forKey:APIHelper.UD_STID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

