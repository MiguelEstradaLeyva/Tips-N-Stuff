//
//  WorkLogViewController.swift
//  Tips N Stuff
//
//  Created by Aaron Diaz on 4/23/18.
//  Copyright © 2018 Aaron Diaz. All rights reserved.
//

import UIKit

class WorkLogViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var shiftHours: UITextField!
    @IBOutlet weak var wageHours: UITextField!
    @IBOutlet weak var expectedPay: UITextField!
    @IBOutlet weak var totalPay: UITextField!
    
    let shiftHrs = 0.00
    let wagePay = 0.00
    var tempPay = 0.00
    var paymentTotals = 0.00
    var tempPaymentTotal = 0.00
    
    let defaults = UserDefaults.standard
    
    
    @IBAction func calculatePay(_ sender: Any) {
        
        if(shiftHours.text?.isEmpty == true || wageHours.text?.isEmpty == true) {
            
            let alert = UIAlertController(title: "Error: Missing fields", message: "Please fill out both fields before calculating pay", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            
            //print("check complete")
        } else {
        
        // Converts the text to double to calculate user paycheck
        let result = (shiftHours.text?.toDouble())! * (wageHours.text?.toDouble())!
        expectedPay.text = "\(result)"
        tempPay = result
        
        // Store the current expected paycheck to add it to running myTotal recieved later on
        let totPay = defaults.double(forKey: "myTotal")
        
        // Temp variable to hold the new total and set it for the key myTotal
        tempPaymentTotal = paymentTotals + totPay
        defaults.set(tempPaymentTotal, forKey: "myTotal")
        
        // Call to update the pay
        updateTotalPay()
        }
        
    }
    
    func updateTotalPay() {
        
        // This is used to grab the current value from myTotal in the user defaults and places it
        // into a temp variable in order to perform calculations with it
        if let userPayTemp = defaults.object(forKey: "myTotal") {
            let holdTemp = userPayTemp as! Double
            
            // Sets the new total value for the key myTotal
            let newTotal = holdTemp + tempPay
            defaults.set(newTotal, forKey: "myTotal")
        }
        
        // Resets text fields for the user so they do not have to delete them
        shiftHours.text = ""
        wageHours.text = ""
        
        // Sets the total pay field to the correct amount
        let totPay = defaults.double(forKey: "myTotal")
        totalPay.text = totPay.toString()
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // This adds a gesture recognizer in order for the user to close the keyboard by tapping anywhere on the screen
        // other than the keyboard itself
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        expectedPay.isUserInteractionEnabled = false
        totalPay.isUserInteractionEnabled = false
        self.shiftHours.keyboardType = UIKeyboardType.decimalPad
        self.wageHours.keyboardType = UIKeyboardType.decimalPad
        self.wageHours.delegate = self
        self.shiftHours.delegate = self
    }
    

    // This function ensures that the textfield can only contain one decimal point
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // If the textfield is NOT empty will check to make sure only has one decimal
        if textField.text?.isEmpty == false {
            let allowedCharacters = CharacterSet(charactersIn:".0123456789").inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            
            // only want to allow 1 decimal point in the string so we can convert it to a double
            if (textField.text?.contains("."))!, string.contains(".") {
                return false
            }
            return string == filtered
        } else {
            return true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // This sets the totalPay label to the current total collected if the user switches views and comes back
        let totPay = defaults.double(forKey: "myTotal")
        totalPay.text = totPay.toString()
    }
}

extension String {
    func toDouble() -> Double? {
        return  NumberFormatter().number(from: self)?.doubleValue
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.2f",self)
    }
}

