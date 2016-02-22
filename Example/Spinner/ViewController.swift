//
//  ViewController.swift
//  Spinner
//
//  Created by Igor Nikitin on 02/05/2016.
//  Copyright (c) 2016 Igor Nikitin. All rights reserved.
//

import UIKit
import Spinner

class ViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    
    private let spinner = Spinner()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func spin(sender: AnyObject) {
        view.endEditing(true)
        spinner.showInView(view, withTitle: messageTextField.text)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.spinner.hide()
        }
    }
    
}

