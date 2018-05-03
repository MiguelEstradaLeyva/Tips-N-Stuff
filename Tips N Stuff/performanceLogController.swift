//
//  PerformanceLog.swift
//  Tips N Stuff
//
//  Created by Don Ostergaard on 4/23/18.
//  Copyright © 2018 Don Ostergaard. All rights reserved.
//

import UIKit

class performanceLogController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var taskTextbox: UITextField!
    
    @IBOutlet weak var postBtn: UIButton!
    
    // server will post tasks and how many tables they served
    @IBOutlet weak var serverField: UITextView!
    
    // textfield with how many tables that have been served
    @IBOutlet weak var servedField: UITextField!
    
    @IBOutlet weak var bkgTextView: UIView!
    
    @IBOutlet weak var mainBkgView: UIView!
    
    @IBOutlet weak var dropDown: UIPickerView!
    
    var BeginingText:String = ""
    
    var tablesServed:String = ""
    
    let defaults = UserDefaults.standard
    
    // The picker list that a user can pick jobs from
    var list = ["N/A", "Served Food", "Cooked Food", "Clean Dishes", "Clean Tables", "Clean Kitchen",
                "Made Drinks", "Bar Tended", "Refills", "Seated Guests", "Meetings", "Did Garbage",
                "Cleaned Bathrooms"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide the picker until the user clicks the textField
        self.dropDown.isHidden = true
        mainBkgView.isHidden = true
        bkgTextView.isHidden = true
        // make keyboard go away when user is done typeing
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        self.servedField.delegate = self
        self.taskTextbox.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // user can only add one job at a time
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
        
    }
    
    // return the job the user has picked from the job list picker obj
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
        
    }
    
    //  save jobs in the appropriate fields
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // allows the user to add multiple tasks to the textField if the field is not empty
        if !((taskTextbox.text?.isEmpty)!){
            self.dropDown.isHidden = true
            mainBkgView.isHidden = true
            bkgTextView.isHidden = true
            taskTextbox.text! += ", " + self.list[row]
            
        }
        else{
            self.taskTextbox.text = self.list[row]
            BeginingText = taskTextbox.text!
            // once the user has picked their task close the menu..
            self.dropDown.isHidden = true
            mainBkgView.isHidden = true
            bkgTextView.isHidden = true
        }
        
    }
    
    // user has clicked the textfield now make the picker come up
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.taskTextbox {
            self.dropDown.isHidden = false
            //So the users cant to use the keyboard to type
            mainBkgView.isHidden = false
            bkgTextView.isHidden = false
            //textField.endEditing(true)
        }
        
    }
    
    // this will ensure that the user has to use the date picker and cant input wrong dates (only #'s)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == servedField){
            // only allow digits in the text field
            let allowedCharacters = CharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            return string == filtered
        }
        return true
    }
    
    // so the log will never be nil
    func start(){
        defaults.set("Start:", forKey:"post")
    }
    
    // this button will allow the servers to post their work to their manager
    @IBAction func postToFieldBtn(_ sender: Any) {
       
        // only bring in old previous saved data into the textview once
        var count = 0
        //here
        // get the saved tasks from a previous session
        //var temp = ""
        var formatedString: String = ""
        
        var temp = defaults.string(forKey: "post")
        
        if(temp == nil){
            defaults.set("Log:", forKey:"post")
            temp = defaults.string(forKey: "post")
        }
        //look here
        if !(temp == "" && count == 0) {
            serverField.text = temp! + "\n"
            count += 1
        }
        
        // how many tables served saved into temp variable for changes
        tablesServed = servedField.text! + " "
        formatedString += "Tables Served: " + tablesServed + "\nTasks Done: " + taskTextbox.text! + "\n"
        
        // post to "server"
        serverField.text! += formatedString
        let all = serverField.text
        
        //save the post to the device
        defaults.set(all,forKey: "post")
    }
    
    // show the user all past posts of their work
    override func viewDidAppear(_ animated: Bool) {
        let temp = defaults.string(forKey: "post")
        serverField.text = temp
        //serverField.endFloatingCursor()
        //serverField.
    }
}

