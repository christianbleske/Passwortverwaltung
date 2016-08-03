//
//  MasterViewController.swift
//  Passwortverwaltung
//
//  Created by Christian Bleske on 29.11.14.
//  Copyright (c) 2014 Christian Bleske. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

class MasterViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext? = nil
    var passworte = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.title = NSLocalizedString("MVC_leftBarButtonItem", comment: "-")
        authenticate();
    }
    
    func authenticate() {
        let laContext = LAContext()
        var error: NSError?
        
        if laContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason =  NSLocalizedString("Msg_Reason_TouchID", comment: "-") //"Überprüfung mit TouchID"                             //B3->4 von NSError -> Error
            laContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: {(succes: Bool, error: Error?) -> Void in
                    if succes {
                        self.showAlertViewWithTitle(NSLocalizedString("Msg_Title", comment: "-"),message: NSLocalizedString("Msg_TouchID_success", comment: "-"))//"Prüfung mit TouchID erfolgreich!")
                    }
                    else {
                        self.showAlertViewWithTitle(NSLocalizedString("Msg_Title", comment: "-"),message: NSLocalizedString("Msg_TouchID_failed", comment: "-"))//"Prüfung mit TouchID nicht erfolgreich!")
                        self.tableView.allowsSelection = false
                    }
            })
        }
            
        else {
            showAlertViewWithTitle(NSLocalizedString("Msg_Title", comment: "-"),message: NSLocalizedString("Msg_TouchID_NA", comment: "-"))//"TouchID nicht verfügbar!")
        }
        
    }

    func showAlertViewWithTitle(_ title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // ...
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func writeData() {
        do {
            try managedObjectContext?.save()
        } catch _ {
        }
    }
    
    func loadData() {
        passworte.removeAllObjects()
        let fetchRequest = NSFetchRequest<Passwort>(entityName: "Passwort")
        
        var fetchResults:[AnyObject]?
        do {
            fetchResults = try managedObjectContext!.fetch(fetchRequest) //as! [Passwort]
            for passwort: Passwort in fetchResults as! [Passwort]{
                print(passwort.name + " " + passwort.passwort)
                passworte.add(passwort)
            }
            self.tableView.reloadData();
        } catch {
            if (fetchResults!.count <= 0) {
                showAlertViewWithTitle("Hinweis", message: "Datensatz nicht gefunden!")
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let pwd = passworte[(indexPath as NSIndexPath).row] as! Passwort
                //B3->B4 Renamed destinationViewController to destination
                (segue.destination as! DetailViewController).detailItem = pwd
            }
        }
    }
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passworte.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        let pwd = passworte[(indexPath as NSIndexPath).row] as! Passwort
        cell.textLabel?.text = pwd.name
        return cell
        
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print( indexPath )
            let pwd = passworte[(indexPath as NSIndexPath).row] as! NSManagedObject
            self.managedObjectContext?.delete(pwd)
            writeData()
            loadData()
            self.tableView.reloadData();
        }
    }

}

