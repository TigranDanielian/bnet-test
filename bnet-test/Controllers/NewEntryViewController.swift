//
//  NewEntryViewController.swift
//  bnet-test
//
//  Created by Tigran Danielian on 09.06.2020.
//  Copyright © 2020 Tigran Danielian. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        saveButton.isEnabled = false
    }
    
    @IBAction func cancelEntry(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text! == "" {
         saveButton.isEnabled = false
        } else {
         saveButton.isEnabled = true
        }
    }
    
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


