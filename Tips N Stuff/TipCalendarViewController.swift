//
//  TipCalendarViewController.swift
//  Tips N Stuff
//
//  Created by Don Ostergaard on 4/10/18.
//  Copyright © 2018 Don Ostergaard. All rights reserved.
//
// https://apoorv.blog/currency-format-input-uitextfield-swift/
import UIKit
import EventKit
import EventKitUI

class TipCalendarViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cal: UIButton!
    @IBOutlet weak var jobField: UITextField!
    @IBOutlet weak var tipAmount: UITextField!
    @IBOutlet weak var DateField: UITextField!
    @IBOutlet weak var NotesField: UITextField!

    var yearlyTipAmount = 0.0
    
    // a UI representation for the user to pick a date. This way the user cannot mess anything up
    let picker = UIDatePicker()
    let defaults = UserDefaults.standard
    
    func createDatePicker(){ 
        
        //tool bar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        DateField.inputAccessoryView = toolbar
        DateField.inputView = picker
        
        // format picker for date field
        picker.datePickerMode = .dateAndTime
    }
    
    func check(sender: UITextField){
        if((jobField.text?.isEmpty)! || (DateField.text?.isEmpty)!){
            cal.isEnabled = false
            let alert = UIAlertController(title: "Please Fill Out all Fields", message: "There must be   Job tiltle and a date before continuing.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        else{
            cal.isEnabled = true
        }
    }
    // when the user presses done after they have choosen a date it locks it in and goes
    // back to the main screen
    @objc func donePressed(){
        cal.isEnabled = true
        let d = picker.date
        let calendar = NSCalendar.current
        let day: String = (String)(calendar.component(Calendar.Component.day, from: d))
        let month: String = (String)(calendar.component(Calendar.Component.month, from: d))
        let year: String = (String)(calendar.component(Calendar.Component.year, from: d))
        let dateKey: String = year + "/" + month + "/" + day
        
        if (money.keys.contains(dateKey)){
            let orgTip:Double = money[dateKey]!
            todayTipField.text = (String)(orgTip)
        }
        
        DateField.text = "\(picker.date)"
        self.view.endEditing(true)
    }
    
    //once the user has filled out all the text fields allow to to add it to their calendar s0
    // they can refer to it at a later date.
    @IBAction func pushToCalendar(_ sender: UIButton) {
        // look at alage app to check fields 1st before you accept them add alert screens for errors
        
        setupAddTargetIsNotEmptyTextFields()

        let d = picker.date
        let calendar = NSCalendar.current
        let day: String = (String)(calendar.component(Calendar.Component.day, from: d))
        let month: String = (String)(calendar.component(Calendar.Component.month, from: d))
        let year: String = (String)(calendar.component(Calendar.Component.year, from: d))
        let dateKey: String = year + "/" + month + "/" + day
        let tipAt: Double
        
        // Re-adding money data in userdefaults otherwise money gets cleared 
        for (k,v) in defaults.dictionaryRepresentation(){
            money[k] = v as? Double
        }
        
        if(tipAmount.text?.isEmpty == true){
            tipAt = 0.0
        }
        else{
            tipAt = (Double)(self.tipAmount.text!)!
            
            // Set the yearlyTipAmount to the user entered amount
            yearlyTipAmount = tipAt
        }
        
        if !(money.keys.contains(dateKey)){
            money[dateKey] = tipAt
            todayTipField.text = (String)(tipAt)
            
            // Store the new date with key-value into userdefaults
            defaults.set(tipAt, forKey: dateKey)
        }
        else{
            let orgTip:Double = money[dateKey]!
            todayTipField.text = (String)(orgTip)
            
            // Store the new date with key-value into userdefaults
            defaults.set(orgTip, forKey: dateKey)
            getTipAmountDay()
        }
        
        // Sets the yearlyTipAmount after getting the data finalized
        defaults.set(yearlyTipAmount, forKey: "yearlyTip")
        
        // All fields in the calendar need to be strings
        let titles: String = "Job Completed: " + jobField.text!
        let tip: String = "Tip amount: $" + tipAmount.text!
        let notes: String = "\nAdditional Notes: " + NotesField.text!
        
        
        
        let eventStore: EKEventStore = EKEventStore()
        // ask user for permission to their calendar so we can add a project event in the calendar
        eventStore.requestAccess(to: .event) {(granted, error) in
            if(granted) && (error == nil)
            {
                print("granted\(granted)")
                print("error \(String(describing: error))")
                
                let event: EKEvent = EKEvent (eventStore: eventStore)
                // adding project fields to the actual calendar
                event.title = titles
                event.startDate = self.picker.date
                event.endDate = self.picker.date
                event.notes = tip + notes
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    // save the event to the ios calendar
                    try eventStore.save(event, span: .thisEvent)
                    // launch ios calendar app with the newly created saved project event
                    self.gotoAppleCalendar(date: event.startDate! as NSDate)
                    
                    
                }catch let error as NSError{
                    print ("error : \(error)")
                }
                print ("Save Event")
                
            }else{
                print("error := \(String(describing: error))")
            }
        }
    }
    
    // This function enables to Tips N stuff to launch the ios calendar with new events.
    func gotoAppleCalendar(date: NSDate) {
        let interval = date.timeIntervalSinceReferenceDate
        // use a system call to notify Tips N stuff to go to the calendar app
        let url = NSURL(string: "calshow:\(interval)")!
        UIApplication.shared.openURL(url as URL)
    }
    
    
    @IBOutlet weak var todayTipField: UITextField!
    @IBOutlet weak var yearsTipField: UITextField!
    
    var todaytotal = 0.0
    var yeartotal = 0.0;
    
    var money = [String: Double]()
    // UserDefaults.standard.set(money, forKey: "money")
    
    func getTipAmountDay(){
        let d = picker.date
        let calendar = NSCalendar.current
        let day: String = (String)(calendar.component(Calendar.Component.day, from: d))
        let month: String = (String)(calendar.component(Calendar.Component.month, from: d))
        let year: String = (String)(calendar.component(Calendar.Component.year, from: d))
        let dateKey: String = year + "/" + month + "/" + day

        
        if money.keys.contains(dateKey){
            
            let orgTip:Double = money[dateKey]!
            let newTip: Double = (Double)(tipAmount.text!)!
            let totalTip = orgTip + newTip
            
            // Get the new updated tip and store it into yearlyTipAmount
            yearlyTipAmount = totalTip
            
            // Update the value of the totalTip for the current date
            money.updateValue(totalTip, forKey: dateKey)
            
            // Set the totalTip for the current date
            defaults.set(totalTip, forKey: dateKey)
            
            todayTipField.text = (String)(totalTip)
            
            // Set the dictionary for money
            defaults.set(money, forKey: "money")
            
            // Set the yearlyTipAmount
            defaults.set(yearlyTipAmount, forKey: "yearlyTip")
            
            // Change the textfield to the current yearlyTipAmount
            yearsTipField.text = yearlyTipAmount.toString()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipAmount.delegate = self
        tipAmount.keyboardType = .numbersAndPunctuation
        cal.isEnabled =  false
        createDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This method is used for updating the textfields with the appropriate values after the user
    // leaves the screen and comes back
    override func viewDidAppear(_ animated: Bool) {
        
        let temp = defaults.double(forKey: "yearlyTip")
        yearsTipField.text = temp.toString()
    }
    
    // this will ensure that the user has to use the date picker and cant input wrong dates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == DateField
        {
            return false
        }
        else if textField == tipAmount{
            // only allow digits and a "." in the text field
            let allowedCharacters = CharacterSet(charactersIn:".0123456789").inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            // only want to allow 1 decimal point in the string so we can convert it to a double
            if (textField.text?.contains("."))!, string.contains(".") {
                return false
            }
            return string == filtered
        }
        else
        {
            return true
        }
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        
        if(!((jobField.text?.isEmpty)! && (tipAmount.text?.isEmpty)! && (DateField.text?.isEmpty)!)){
            cal.isEnabled = true
        }
        else{
            cal.isEnabled = false
        }
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let job = jobField.text, !job.isEmpty,
            let tip = tipAmount.text, !tip.isEmpty,
            let dt = DateField.text, !dt.isEmpty
            
            else
        {
            cal.isUserInteractionEnabled = true
            return
        }
        // enable okButton if all conditions are met
        cal.isUserInteractionEnabled = false
    }
}
