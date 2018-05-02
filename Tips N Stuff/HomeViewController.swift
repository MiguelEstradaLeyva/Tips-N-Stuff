//
//  HomeViewController.swift
//  Tips N Stuff
//
//  Created by Aaron Diaz on 4/10/18.
//  Copyright © 2018 Aaron Diaz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var performBtn: UIButton!
    @IBOutlet weak var calBtn: UIButton!
    
    @IBOutlet weak var workBtn: UIButton!
    @IBOutlet weak var calcBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // give the buttons card view look
        //youthBtn.layer.cornerRadius = 10
        calBtn.layer.shadowColor = UIColor.darkGray.cgColor
        calBtn.layer.shadowOffset = CGSize(width:0, height: 1.95)
        calBtn.layer.shadowRadius = 1.7
        calBtn.layer.shadowOpacity = 0.55
        
        //topsBtn.layer.cornerRadius = 10
        calcBtn.layer.shadowColor = UIColor.darkGray.cgColor
        calcBtn.layer.shadowOffset = CGSize(width:0, height: 1.95)
        calcBtn.layer.shadowRadius = 1.7
        calcBtn.layer.shadowOpacity = 0.55
        
        // give the buttons card view look
        //youthBtn.layer.cornerRadius = 10
        performBtn.layer.shadowColor = UIColor.darkGray.cgColor
        performBtn.layer.shadowOffset = CGSize(width:0, height: 1.95)
        performBtn.layer.shadowRadius = 1.7
        performBtn.layer.shadowOpacity = 0.55
        
        //topsBtn.layer.cornerRadius = 10
        workBtn.layer.shadowColor = UIColor.darkGray.cgColor
        workBtn.layer.shadowOffset = CGSize(width:0, height: 1.95)
        workBtn.layer.shadowRadius = 1.7
        workBtn.layer.shadowOpacity = 0.55
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
