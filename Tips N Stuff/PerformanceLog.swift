//
//  PerformanceLog.swift
//  Tips N Stuff
//
//  Created by Don Ostergaard on 4/23/18.
//  Copyright © 2018 Don Ostergaardz. All rights reserved.
//

import UIKit

class PerformanceLog: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var taskTextbox: UITextField!
    
    @IBOutlet weak var servedField: UITextField!
    
    @IBOutlet weak var bkgTextView: UIView!
    
    @IBOutlet weak var mainBkgView: UIView!
    
    @IBOutlet weak var dropDown: UIPickerView!
    
    var BeginingText:String = ""
    
    var list = ["Served Food", "Cooked Food", "Clean Dishes", "Clean Tables", "Clean Kitchen",
                "Made Drinks", "Bar Tended", "Refills", "Seated Guests", "Meetings", "Did Garbage",
                "Cleaned Bathrooms"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dropDown.isHidden = true
        mainBkgView.isHidden = true
        bkgTextView.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // allows the user to add multiple tasks to the textField 
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.taskTextbox {
            self.dropDown.isHidden = false
             //So the users cant to use the keyboard to type
            mainBkgView.isHidden = false
            bkgTextView.isHidden = false
            //textField.endEditing(true)
        }
        
    }
    
    // this will ensure that the user has to use the date picker and cant input wrong dates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == servedField{
            // only allow digits in the text field
            let allowedCharacters = CharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            // only want to allow 1 decimal point in the string so we can convert it to a double
            
            return string == filtered
        }
        return true
    }
}
