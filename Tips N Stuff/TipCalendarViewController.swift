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
    
    @IBOutlet weak var jobField: UITextField!
    @IBOutlet weak var tipAmount: UITextField!
    @IBOutlet weak var DateField: UITextField!
    @IBOutlet weak var NotesField: UITextField!
    
    // a UI representation for the user to pick a date. This way the user cannot mess anything up
    let picker = UIDatePicker()
    
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
    // when the user presses done after they have choosen a date it locks it in and goes
    // back to the main screen
    @objc func donePressed(){
        let d = picker.date
        let calendar = NSCalendar.current
        let day: String = (String)(calendar.component(Calendar.Component.day, from: d))
        let month: String = (String)(calendar.component(Calendar.Component.month, from: d))
        let year: String = (String)(calendar.component(Calendar.Component.year, from: d))
        let dateKey: String = year + "/" + month + "/" + day
        //let tipAt: Double = (Double)(self.tipAmount.text!)!
        
        if (money.keys.contains(dateKey)){
            let orgTip:Double = money[dateKey]!
            todayTipField.text = (String)(orgTip)
           // getTipAmountDay()
        }
        DateField.text = "\(picker.date)"
        self.view.endEditing(true)
    }
    
    //once the user has filled out all the text fields allow to to add it to their calendar s0
    // they can refer to it at a later date.
    @IBAction func pushToCalendar(_ sender: UIButton) {
        // look at alage app to check fields 1st before you accept them add alert screens for errors
        
        let d = picker.date
        let calendar = NSCalendar.current
        let day: String = (String)(calendar.component(Calendar.Component.day, from: d))
        let month: String = (String)(calendar.component(Calendar.Component.month, from: d))
        let year: String = (String)(calendar.component(Calendar.Component.year, from: d))
        let dateKey: String = year + "/" + month + "/" + day
        let tipAt: Double = (Double)(self.tipAmount.text!)!
        
        if !(money.keys.contains(dateKey)){
        //money.updateValue(tipAt, forKey: dateKey)
        money[dateKey] = tipAt
            todayTipField.text = (String)(tipAt)
        }
        else{
            let orgTip:Double = money[dateKey]!
            todayTipField.text = (String)(orgTip)
          getTipAmountDay()
        }
        
        // All fields in the calendar need to be strings
        let titles: String = "Job Completed: " + jobField.text!
        let tip: String = "Tip amount: $" + tipAmount.text!
        let notes: String = "\nAdditional Notes: " + NotesField.text!
       
        
        
        // make a dictionary that holds dates(key) with tip totals (value)
        // grab the date then add a total add put it in the today's tip total field
        // might wanna make another method to do this and just call it from this method
        // dayTot(date: date 2, Double: todaytotal)
        // check if date is in dictionary if is add to it else add the date to the dict. and
        // start a new total
        //var t = Double(tipAmount.text!)
        //todaytotal += t!
        //todayTipField.text = String(todaytotal)
        
        
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
        //var day: String = picker.date.description
        if money.keys.contains(dateKey){
            let orgTip:Double = money[dateKey]!
            let newTip: Double = (Double)(tipAmount.text!)!
            let totalTip = orgTip + newTip
            money.updateValue(totalTip, forKey: dateKey)
            todayTipField.text = (String)(totalTip)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        UserDefaults.standard.set(money, forKey: "money")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // this will ensure that the user has to use the date picker and cant input wrong dates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == DateField
        {
    return false
        }
    else
        {
    return true
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/*
 let date1 = Date()
 let calendar = Calendar.current
 let hour = calendar.component(.hour, from: date1)
 let minutes = calendar.component(.minute, from: date1)
 let seconds = calendar.component(.second, from: date1)
 
 let dateFormatter = DateFormatter()
 //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
 dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
 /*  let raceDate = DateField.text! +  " " + String(describing: hour) + ":" + String(describing: minutes) +
 ":" + String(describing: seconds)
 let date = dateFormatter.date(from: raceDate)
 // let minimumDate = NSDate()
 */
 let raceDate = DateField.text
 let date = dateFormatter.date(from: raceDate!)
 */
