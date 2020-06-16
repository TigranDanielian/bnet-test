//
//  EntriesViewController.swift
//  bnet-test
//
//  Created by Tigran Danielian on 07.06.2020.
//  Copyright © 2020 Tigran Danielian. All rights reserved.
//

import UIKit
import Network
import SystemConfiguration

    

class EntriesViewController: UITableViewController {
    
    
    let NM = NetworkManager()
    var modelsArray: [DataModel]=[]
         
    override func viewDidLoad() {
        super.viewDidLoad()
        NM.delegate = self
        checkInternet()

    }
    
    func checkInternet() {
       let alert = UIAlertController(title: "No internet connection", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Update data", style: .default) { _ in
            self.checkInternet()
        }
           alert.addAction(action)
        if NetworkManager.isConnectedToNetwork() {
            NM.newSession()
            NM.getEntries()
             tableView.reloadData()
        } else {
            present(alert, animated: true)
        }
    }
    
 
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
       //NM.performRequest(method: addEntry, body: nil)
        
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        if let svc = segue.source as? NewEntryViewController {
            guard let t = svc.textView.text else {return}
             DispatchQueue.main.async {
                self.NM.addEntry(body: t)
                self.NM.getEntries()
                self.tableView.reloadData()
            }
            
    }

    }
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelsArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFullEntry", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")

        if !modelsArray.isEmpty {
        let da = Date(timeIntervalSince1970: TimeInterval(modelsArray[indexPath.row].dateAdded!))
        let dm = Date(timeIntervalSince1970: TimeInterval(modelsArray[indexPath.row].dateModified!))
        cell.bodyLabel.text = modelsArray[indexPath.row].entry
        cell.daLabel.text = "Created: \(dateFormatter.string(from: da))"
        cell.dmLabel.text = "Modified: \(dateFormatter.string(from: dm))"
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? FullEntryViewController else {return}
        if let indexPath = tableView.indexPathForSelectedRow {
            print(indexPath.row)
            guard let t = modelsArray[indexPath.row].entry else {return}
            destinationVC.text = t
        }
    }
    
}

extension EntriesViewController: NetworkManagerDelegate {
     func didUpdateData(_: NetworkManager, models: [DataModel]) {
        if !models.isEmpty {
        DispatchQueue.main.async {
        self.modelsArray = models
        print(self.modelsArray[0].entry!)
        self.tableView.reloadData()
        }
        }
        
    }
    
    
    
    
}



