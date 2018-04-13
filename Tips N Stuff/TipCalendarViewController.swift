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
        // All fields in the calendar need to be strings
        let titles: String = "Job Completed: " + jobField.text!
        let descriptions: String = "Tip amount: $" + tipAmount.text!
        let notes: String = "\nAdditional Notes: " + NotesField.text!
        
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //'T'HH:mm:ssZZZZZ"
       // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let raceDate = DateField.text
        let date = dateFormatter.date(from: raceDate!)
       
        let date2 = Date(timeInterval: 01.0, since: date!)
        
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
                event.notes = descriptions + notes
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
    
    @IBOutlet weak var todayTipField: UITextField!
    
    @IBOutlet weak var yearsTipField: UITextField!
    
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
