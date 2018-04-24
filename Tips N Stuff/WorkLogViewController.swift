//
//  WorkLogViewController.swift
//  Tips N Stuff
//
//  Created by Aaron Diaz on 4/23/18.
//  Copyright © 2018 Aaron Diaz. All rights reserved.
//

import UIKit

class WorkLogViewController: UIViewController {

    @IBOutlet weak var shiftHours: UITextField!
    @IBOutlet weak var wageHours: UITextField!
    @IBOutlet weak var expectedPay: UITextField!
    @IBOutlet weak var totalPay: UITextField!
    
    let shiftHrs = 0.0
    let wagePay = 0.0
    let userDef = UserDefaults.standard
    
    @IBAction func calculatePay(_ sender: Any) {
        let result = (shiftHours.text?.toDouble())! * (wageHours.text?.toDouble())!
        expectedPay.text = "\(result)"
        
        userDef.set(result, forKey: "paycheck") 
        let pay = userDef.double(forKey: "paycheck")
        
        totalPay.text = "\(pay)"
        
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
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension String {
    func toDouble() -> Double? {
        return  NumberFormatter().number(from: self)?.doubleValue
    }
}

