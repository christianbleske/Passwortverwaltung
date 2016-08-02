//
//  DetailViewController.swift
//  Passwortverwaltung
//
//  Created by Christian Bleske on 29.11.14.
//  Copyright (c) 2014 Christian Bleske. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

   
    @IBOutlet var uiLabelName: UILabel!
    @IBOutlet var uiTextView: UITextView!
    @IBOutlet var uiLabelPasswort: UILabel!

    var detailItem: Passwort?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Passwort = self.detailItem {

            /* println(detail.passwort)
            println(detail.bemerkung)
            println(detail.name) */
            
            self.uiLabelName.text = detail.name
            self.uiLabelPasswort.text = detail.passwort
            self.uiTextView.text = detail.bemerkung
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

