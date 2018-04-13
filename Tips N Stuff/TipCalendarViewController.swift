//
//  TipCalendarViewController.swift
//  Tips N Stuff
//
//  Created by Don Ostergaard on 4/10/18.
//  Copyright © 2018 Don Ostergaard. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class TipCalendarViewController: UIViewController {

    @IBOutlet weak var jobField: UITextField!
    @IBOutlet weak var tipAmount: UITextField!
    @IBOutlet weak var DateField: UITextField!
    @IBOutlet weak var NotesField: UITextField!
    
    
    @IBAction func pushToCalendar(_ sender: UIButton) {
        // look at alage to check fields 1st before you accept them add alert screens for errors
        
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
        var t = Double(tipAmount.text!)
        todaytotal += t!
        todayTipField.text = String(todaytotal)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //'T'HH:mm:ssZZZZZ"
       // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let raceDate = DateField.text
        let date = dateFormatter.date(from: raceDate!)
        let date2 = Date(timeInterval: 01.0, since: date!)
        currentDate = date2
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
                event.startDate = date2
                event.endDate = date2
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
    
    // This function enables the Maruf app to launch the ios calendar with new events.
    func gotoAppleCalendar(date: NSDate) {
        let interval = date.timeIntervalSinceReferenceDate
        // use a system call to notify Maruf to go to the calendar app
        let url = NSURL(string: "calshow:\(interval)")!
        UIApplication.shared.openURL(url as URL)
    }
    
    var currentDate = Date()
    @IBOutlet weak var todayTipField: UITextField!
    
    @IBOutlet weak var yearsTipField: UITextField!
    
    var todaytotal = 0.0
    var yeartotal = 0.0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
