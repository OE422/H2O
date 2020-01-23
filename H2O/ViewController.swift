//
//  ViewController.swift
//  H2O
//
//  Created by  on 1/14/20.
//  Copyright © 2020 oeldoronki80. All rights reserved.
//

import UIKit
import CircleProgressBar

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var completion: CircleProgressBar!
    @IBOutlet weak var adjustmentView: UIBarButtonItem!
    @IBOutlet weak var updateProgress: UIImageView!
    @IBOutlet weak var historyButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var goalInOz: UILabel!
    var waterGoal:Double?
    var waterConsumed:Double?
    var oldDate:Calendar?
    @IBOutlet weak var consumptionInOz: UILabel!
    let numOuncesTF = UITextField()
    let defaults = UserDefaults.standard
    var x = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()

        consumptionInOz.isHidden = true
        goalInOz.isHidden = true
        view.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.0, green: 0.0, blue: 100.0, alpha: 0.5))
        updateProgress.isUserInteractionEnabled = true
        let plusButtonTapped = UITapGestureRecognizer(target: self, action: #selector(updateProgressButtonPressed(sender:)))
        updateProgress.addGestureRecognizer(plusButtonTapped)
        
        numOuncesTF.delegate = self
        
        resetButton.addTarget(self, action: #selector(resetUserDefaults(sender:)), for: .touchUpInside)
        resetButton.layer.cornerRadius = 5
        adjustmentView.target = self
        adjustmentView.action = #selector(goToAdjustGoals(sender:))
        
        historyButton.target = self
        historyButton.action = #selector(viewHistory(sender:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.defaults.object(forKey: "Goal") != nil
        {
            waterGoal = (self.defaults.object(forKey: "Goal") as! Double)
//            waterConsumed = (self.defaults.object(forKey: "Progress") as! Double)
            goalInOz.text = " / \(Double(self.waterGoal!)) oz"
            goalInOz.sizeToFit()
            goalInOz.isHidden = false
            consumptionInOz.text = "\(waterConsumed ?? 0.0)"
            consumptionInOz.isHidden = false
            consumptionInOz.sizeToFit()
            
            if self.defaults.object(forKey: "Progress") != nil
            {
                waterConsumed = (self.defaults.object(forKey: "Progress") as! Double)
                let progress =  self.defaults.object(forKey: "Progress") as! Double / self.waterGoal!
                self.completion.setProgress(CGFloat(progress), animated: true)
            }
        }
//        if self.defaults.object(forKey: "Date") != nil
//        {
//            oldDate = (self.defaults.object(forKey: "Date") as! Calendar)
//        }
//        self.defaults.set(Calendar.current, forKey: "Date")
//        if oldDate == nil
//        {
//            oldDate = Calendar.current
//        }
//        if oldDate != (self.defaults.object(forKey: "Date") as! Calendar)
//        {
//            self.defaults.set(nil, forKey: "Progress")
//            self.completion.setProgress(CGFloat(0.0), animated: true)
//            self.waterConsumed = nil
//        }
    }
    @objc func viewHistory (sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: "viewTheHistory", sender: self)
    }
    @objc func resetUserDefaults (sender: UIButton)
    {
        let doYouWantToReset = UIAlertController(title: "Do you really want to reset your progress?", message: "Once reset, data cannot be restored.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler:{action in
            self.defaults.set(nil, forKey: "Progress")
            self.completion.setProgress(CGFloat(0.0), animated: true)
            self.waterConsumed = nil
            self.consumptionInOz.text = "\(self.waterConsumed ?? 0.0)"
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {
        action in })
        
        doYouWantToReset.addAction(cancel)
        doYouWantToReset.addAction(confirm)
        present(doYouWantToReset, animated: true, completion: nil)
    }
    @objc func updateProgressButtonPressed (sender: UITapGestureRecognizer)
    {
        let numOuncesUpdated = UIAlertController(title: "Add ounces:", message: "", preferredStyle: .alert)
        numOuncesUpdated.addTextField(configurationHandler: { (numOuncesTF) in
             numOuncesTF.placeholder = "Ex. 17"
             numOuncesTF.keyboardType = .numberPad
         })
        let noWGError = UIAlertController(title: "Insufficient Data", message: "You must set a water goal before updating your water consumption.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler:{action in })
        noWGError.addAction(ok)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {
        action in })
        if waterGoal == nil
        {
            present(noWGError, animated: true, completion: nil)
        }
        else
        {
            let add = UIAlertAction(title: "Add", style: .default, handler: {
            action in
                
                
                let value:Double = Double(numOuncesUpdated.textFields![0].text!) ?? 0.0
                if self.defaults.object(forKey: "Progress") == nil
                {
                    self.waterConsumed = value
                    self.defaults.set(value, forKey: "Progress")
                }
                else
                {
                    self.waterConsumed! += value
                    self.defaults.set(self.waterConsumed!, forKey: "Progress")
                }
                let progress = (self.waterConsumed!) / self.waterGoal!
                self.completion.setProgress(CGFloat(progress), animated: true)
                self.consumptionInOz.text = "\(self.waterConsumed!)"
                self.consumptionInOz.sizeToFit()
            })
            numOuncesUpdated.addAction(cancel)
            numOuncesUpdated.addAction(add)
            present(numOuncesUpdated, animated: true, completion: nil)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let progress = (Double((numOuncesTF.text)!)! / waterGoal!)
        completion.setProgress(CGFloat(progress), animated: true)
    }
    @objc func goToAdjustGoals (sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: "adjustTheGoals", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    }

    
}

