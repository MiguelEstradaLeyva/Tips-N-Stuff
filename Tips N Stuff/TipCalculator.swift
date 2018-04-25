//
//  TipCalculator.swift
//  Tips N Stuff
//
//  Created by Miguel Estrada on 4/23/18.
//  Copyright © 2018 Aaron Diaz. All rights reserved.
//

import UIKit

class TipCalculator: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var TipAmountLabel: UILabel!
    @IBOutlet weak var CustomTippercentageLabel1: UILabel!
    @IBOutlet weak var CustomTipPercentageSlider: UISlider!
    @IBOutlet weak var TipFiftheenLabel: UILabel!
    @IBOutlet weak var CustomTippercentage2: UILabel!
    @IBOutlet weak var TotalFifteenLabel: UILabel!
    @IBOutlet weak var TipCustomLabel: UILabel!
    @IBOutlet weak var TotalCustomLabel: UILabel!
    @IBOutlet weak var InputTextField: UITextField!
    
    let decimal100 = NSDecimalNumber(string: "100.0")
    let decimal15Percent = NSDecimalNumber(string: "0.15")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //InputTextField.becomeFirstResponder()
        //InputTextField.keyboardType = UIKeyboardType.numberPad
        InputTextField.keyboardType = .numberPad
        //let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("tap:")))
        //view.addGestureRecognizer(tapGesture)
        self.hideKeyboard()
    }
    
    //func tap(gesture: UITapGestureRecognizer) {
        //InputTextField.resignFirstResponder()
   // }

    //func dismissKeyboard (_ sender: UITapGestureRecognizer) {
       // InputTextField.resignFirstResponder()
    //}
    //func touchhesBegan(_touches: Set<UITouch>, with event: UIEvent?){
    //self.view.endEditing(true)
    
  //  }
    
    @IBAction func CalculateTip(_ sender: Any) {
        let inputString = InputTextField.text
       
        let sliderValue = NSDecimalNumber(integerLiteral:Int ( CustomTipPercentageSlider.value))
        let customPercent = sliderValue / decimal100
        
        if sender is UISlider {
            // thumb moved so update the Labels with new custom percent
            CustomTippercentageLabel1.text = NumberFormatter.localizedString(from: customPercent, number: NumberFormatter.Style.percent)
            CustomTippercentage2.text = CustomTippercentageLabel1.text
            //added this to see what happens
           // CustomTippercentageLabel1.text = CustomTippercentageLabel1.text
            
        }
        // if there is a bill amount, calculate tips and totals
        if !(inputString?.isEmpty)! {
            // convert to NSDecimalNumber and insert decimal point
            let tipAmount =
                NSDecimalNumber(string: inputString) / decimal100
            // did inputTextField generate the event?
            if sender is UITextField {
                // update billAmountLabel with currency-formatted total
                TipAmountLabel.text = " " + TipCalculator.formatAsCurrency(number: tipAmount)
                // calculate and display the 15% tip and total
                let fifteenTip = tipAmount * decimal15Percent
                TipFiftheenLabel.text = TipCalculator.formatAsCurrency(number: fifteenTip)
                TotalFifteenLabel.text =
                    TipCalculator.formatAsCurrency(number: tipAmount + fifteenTip)
            }
            // calculate custom tip and display custom tip and total
            let customTip = tipAmount * customPercent
            TipCustomLabel.text = TipCalculator.formatAsCurrency(number: customTip)
            TotalCustomLabel.text =
                TipCalculator.formatAsCurrency(number: tipAmount + customTip)
        }
        else { // clear all Labels
            TipAmountLabel.text = ""
            TipFiftheenLabel.text = ""
            TotalFifteenLabel.text = ""
            TipCustomLabel.text = ""
            TotalCustomLabel.text = ""
        }
        
    }

    static func formatAsCurrency(number: NSNumber) -> String {
        return NumberFormatter.localizedString(
            from: number, number: NumberFormatter.Style.currency)
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

func +(left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber{
    return left.adding(right)
}
func *(left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber{
    return left.multiplying(by: right)
}
func /(left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber{
    return left.dividing(by: right)
}
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
