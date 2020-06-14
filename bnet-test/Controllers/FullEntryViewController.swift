//
//  FullEntryViewController.swift
//  bnet-test
//
//  Created by Tigran Danielian on 13.06.2020.
//  Copyright © 2020 Tigran Danielian. All rights reserved.
//

import UIKit

class FullEntryViewController: UIViewController, UITextViewDelegate {
    
    var text: String = ""
    
    @IBOutlet weak var entryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryTextView.delegate = self
        entryTextView.text = text
    }
}
