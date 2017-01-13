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
    
    fileprivate let spinner = Spinner()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func spin(_ sender: AnyObject) {
        view.endEditing(true)
        spinner.showInView(view: view, withTitle: messageTextField.text)
        
        let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.spinner.hide()
        }
    }
    
}

