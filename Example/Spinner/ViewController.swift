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
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hide"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func spin(sender: AnyObject) {
        view.endEditing(true)
        if let message = messageTextField.text where message.characters.count > 0 {
            spinner.titleLabel.text = message
            spinner.showInView(view)
        } else {
            spinner.titleLabel.text = nil
            spinner.showInView(view)
        }
    }
    
    func hide() {
        spinner.hide()
    }
    
}

