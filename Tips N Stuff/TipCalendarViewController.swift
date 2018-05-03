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
    
    @IBOutlet weak var cal: UIButton!               //add to calendar button. (tips, date, notes)
    @IBOutlet weak var jobField: UITextField!       //what job the user did (user input)
    @IBOutlet weak var tipAmount: UITextField!      //user enters how much money they got as a tip
    @IBOutlet weak var DateField: UITextField!      // user picks a date and saves it as a string
    @IBOutlet weak var NotesField: UITextField!     //additional comments if user wants to
    
    //output
    //todayTipField: the current day the user has entered adds all the tips for that day
    @IBOutlet weak var todayTipField: UITextField!
    // yearsTipField: adds up all the tips for the user so they can see how much they have made in tips
    @IBOutlet weak var yearsTipField: UITextField!
    
    var todaytotal = 0.0
    var yeartotal = 0.0;
    
    var money = [String: Double]()      // dictionary holds all dates and tip totals with each key
    var yearlyTipAmount = 0.0
    var t = 0.0
    
    // a UI representation for the user to pick a date. This way the user cannot mess anything up
    let picker = UIDatePicker()
    let defaults = UserDefaults.standard        // user store data
    
    // makes a date picker, so it can be placed inside the textfield for the date
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
    
    // ensure that the user has entered in the required fields. If they did enable the button
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
    // back to the main screen. IE the date picker is out of view on the screen
    @objc func donePressed(){
        cal.isEnabled = true
        // get all the date elements so we can store it for the dictionary money. Dates are keys
        let d = picker.date
        let calendar = NSCalendar.current
        let day: String = (String)(calendar.component(Calendar.Component.day, from: d))
        let month: String = (String)(calendar.component(Calendar.Component.month, from: d))
        let year: String = (String)(calendar.component(Calendar.Component.year, from: d))
        let dateKey: String = year + "/" + month + "/" + day
        // if the date is already in the dictionary put it in the out put text field for day amount
        if (money.keys.contains(dateKey)){
            let orgTip:Double = money[dateKey]!
            todayTipField.text = (String)(orgTip)
        }
        // place the date as text in the textfield filling it out for the user (avoids any errors)
        DateField.text = "\(picker.date)"
        self.view.endEditing(true)
    }


    //once the user has filled out all the text fields, allow them to to add it to their calendar so
    // they can refer to it at a later date. They will need a date and a value should have a job too
    @IBAction func pushToCalendar(_ sender: UIButton) {
        
        setupAddTargetIsNotEmptyTextFields()        // verify the textfields are filled out
        
        let h = tipAmount.text?.toDouble()          // h: holds the value $ from the textfield
        t = h! + t                         // t: total has the last value and the new value(add them)
        let temp = defaults.double(forKey: "testing")
        
        // if there isn't a value for the year ie value = 0, set the start value to t
        // should only be 0 when the user saves data for the 1st time
        if (temp == 0.0 || temp == 0){
        defaults.set(t,forKey: "testing")
        }
        
        // gather all date information from the user. used for dictionary
        let d = picker.date
        let calendar = NSCalendar.current
        let day: String = (String)(calendar.component(Calendar.Component.day, from: d))
        let month: String = (String)(calendar.component(Calendar.Component.month, from: d))
        let year: String = (String)(calendar.component(Calendar.Component.year, from: d))
        let dateKey: String = year + "/" + month + "/" + day
        let tipAt: Double       // tipAt(tipAmount): saves how much the user gets tipped
        
        // Re-adding money data in userdefaults otherwise money gets cleared 
        for (k,v) in defaults.dictionaryRepresentation(){
            money[k] = v as? Double
        }
        
        // if the user did not enter a tip amount put zero in for them. Avoid nil values
        if(tipAmount.text?.isEmpty == true){
            tipAt = 0.0
        }
            // they did enter a tip amount so save it off
        else{
            tipAt = (Double)(self.tipAmount.text!)!
            // Set the yearlyTipAmount to the user entered amount
            //yearlyTipAmount = tipAt
        }
        
        // if the dictionary does not have the date in it make it a new key and add total day tips up
        if !(money.keys.contains(dateKey)){
            money[dateKey] = tipAt
            todayTipField.text = (String)(tipAt)
            
            // Store the new date with key-value into userdefaults
            defaults.set(tipAt, forKey: dateKey)
        }
            // the day already is in the dictionary so grab the old value and add the new value to it
        else{
            let orgTip:Double = money[dateKey]!
            todayTipField.text = (String)(orgTip)
            
            // Store the new date with key-value into userdefaults
            defaults.set(orgTip, forKey: dateKey)
            // do the caluclatons
            getTipAmountDay()
        }
        
        // Sets the yearlyTipAmount after getting the data finalized
        defaults.set(yearlyTipAmount, forKey: "yearlyTip")
        
        // All fields in the calendar need to be strings
        let titles: String = "Job Completed: " + jobField.text!
        let tip: String = "Tip amount: $" + tipAmount.text!
        let notes: String = "\nAdditional Notes: " + NotesField.text!
        
        
        // add all user input to the calendar
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
    
    // This function enables to Tips N stuff to launch the ios calendar with new user input.
    func gotoAppleCalendar(date: NSDate) {
        let interval = date.timeIntervalSinceReferenceDate
        // use a system call to notify Tips N stuff to go to the calendar app
        let url = NSURL(string: "calshow:\(interval)")!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    

    // update the tips for the given day (add original tip to new tip to get a total)
    func getTipAmountDay(){
        let d = picker.date
        let calendar = NSCalendar.current
        let day: String = (String)(calendar.component(Calendar.Component.day, from: d))
        let month: String = (String)(calendar.component(Calendar.Component.month, from: d))
        let year: String = (String)(calendar.component(Calendar.Component.year, from: d))
        let dateKey: String = year + "/" + month + "/" + day

        // if the dictionary has the date get that dates value and add the new tip to it
        if money.keys.contains(dateKey){
            
            let orgTip:Double = money[dateKey]!
            let newTip: Double = (Double)(tipAmount.text!)!
            let totalTip = orgTip + newTip
            
            //for testing
            var temp = defaults.double(forKey: "testing")
            print("old value: " , temp , " + ")
            temp += newTip
            print("newTip: " , newTip , " = " , temp)
            
            //testing year value
            defaults.set(temp, forKey:"testing")
            
            // Get the new updated tip and store it into yearlyTipAmount
            yearlyTipAmount = temp
            
            // Update the value of the totalTip for the current date
            money.updateValue(totalTip, forKey: dateKey)
            
            // Set the totalTip for the current date
            defaults.set(totalTip, forKey: dateKey)
            
            todayTipField.text = (String)(totalTip)
            
            // Set the dictionary for money
            defaults.set(money, forKey: "money")
            

            
            // Set the yearlyTipAmount
            //defaults.set(yearlyTipAmount, forKey: "yearlyTip")
            
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
        
        let temp = defaults.double(forKey: "testing")
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
