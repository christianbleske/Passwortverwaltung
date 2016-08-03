//
//  Generator.swift
//  Passwortverwaltung
//
//  Created by Christian Bleske on 29.11.14.
//  Copyright (c) 2014 Christian Bleske. All rights reserved.
//

import UIKit
import CoreData

class GeneratorViewController : UIViewController, UITextFieldDelegate  {
    
    var newPasswort:String?
    var currentValue:Int=10
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    @IBOutlet var uiSlider: UISlider!
    @IBOutlet var uiSwitch: UISwitch!
    @IBOutlet var labelSliderValue: UILabel!
    @IBOutlet var uiTextFieldPwd: UITextField!
    @IBOutlet var uiTextFieldName: UITextField!
    @IBOutlet var uiTextView: UITextView!
    
    let strCharacters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9,","0","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //println(generatePwd(10, withCapOnly:true))
        //println(generatePwd(10, withCapOnly:false))
        labelSliderValue.text = String(currentValue)
        self.uiTextFieldName.delegate = self;
        self.uiTextFieldPwd.delegate = self;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getRandomNumber(_ min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    
    func generatePwd(_ leng : Int, withCapOnly : Bool) -> String {
        var result:String=""
        
        var stop=0
        
        if withCapOnly==true {
            stop=35
        } else {
            stop=60
        }
        
        //Nur bis Swift 2.2. -> for var x = 0; x <= leng; x++
        var x = 0
        while (x<=leng)
        {
            let p = getRandomNumber(0, max: stop)
            result = result + strCharacters[p]
            x+=1
        }
        
        return result
    }
 
    @IBAction func btnPasswort_Pressed(_ sender: AnyObject) {
        if uiSwitch.isOn {
            newPasswort = generatePwd(currentValue, withCapOnly:true)
        } else  {
            newPasswort = generatePwd(currentValue, withCapOnly:false)
        }
        
        self.uiTextFieldPwd.text = newPasswort
        
    }
    
    @IBAction func btnSpeichern_Pressed(_ sender: AnyObject) {
        let pwd = NSEntityDescription.insertNewObject(forEntityName: "Passwort", into: self.managedObjectContext!) as!Passwort
        pwd.name = self.uiTextFieldName.text!
        pwd.passwort = self.uiTextFieldPwd.text!
        pwd.bemerkung = self.uiTextView.text
        
        do {
            try managedObjectContext?.save()
        } catch _ {
        }
        
        showAlertViewWithTitle(NSLocalizedString("Msg_Title", comment: "-"), message: NSLocalizedString("Msg_PwdSaved", comment: "-"))//"Passwort wurde gespeichert!")
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        currentValue = Int(sender.value)
        labelSliderValue.text = String(currentValue)
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
    
}
