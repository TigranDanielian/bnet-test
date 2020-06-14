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
    
    var NM = NetworkManager()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        

    }
    
    @IBAction func saveEntry(_ sender: UIButton) {
        if textView.text!.isEmpty {
         let alert = UIAlertController(title: "Empty entry", message: "Please fill the entry!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelEntry(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
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


