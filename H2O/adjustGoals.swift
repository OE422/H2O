//
//  adjustGoals.swift
//  H2O
//
//  Created by  on 1/15/20.
//  Copyright © 2020 oeldoronki80. All rights reserved.
//

import UIKit

class adjustGoals: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var enterWeightButton: UIButton!
    @IBOutlet weak var customGoalButton: UIButton!
    @IBOutlet weak var entryTF: UITextField!
    @IBOutlet weak var customEntryTF: UITextField!
    @IBOutlet weak var EYWLabel: UILabel!
    @IBOutlet weak var EYWGLabel: UILabel!
    @IBOutlet weak var kgOrLbs: UISegmentedControl!
    @IBOutlet weak var yourWaterGoal: UITextView!
    @IBOutlet weak var doctorRecommendation: UITextView!
    @IBOutlet weak var okBackToVC: UIButton!
    let defaults = UserDefaults.standard
    var numOunces:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
        entryTF.delegate = self
        customEntryTF.delegate = self
        
        enterWeightButton.isHidden = false
        customGoalButton.isHidden = false
        entryTF.isHidden = true
        customEntryTF.isHidden = true
        EYWLabel.isHidden = true
        EYWGLabel.isHidden = true
        kgOrLbs.isHidden = true
        yourWaterGoal.isHidden = true
        okBackToVC.isHidden = true
        entryTF.keyboardType = .numberPad
        customEntryTF.keyboardType = .numberPad
        
        enterWeightButton.layer.cornerRadius = 5
        customGoalButton.layer.cornerRadius = 5
        okBackToVC.layer.cornerRadius = 5
        
        okBackToVC.addTarget(self, action: #selector(backToVC(sender:)), for: .touchUpInside)
        kgOrLbs.addTarget(self, action: #selector(massUnitsSwitched(sender:)), for: .allEvents)
        enterWeightButton.addTarget(self, action: #selector(weightButtonPressed(sender:)), for: .touchUpInside)
        customGoalButton.addTarget(self, action: #selector(customButtonPressed(sender:)), for: .touchUpInside)
        view.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.0, green: 0.0, blue: 100.0, alpha: 0.5))
    }
    @objc func backToVC (sender: UIButton)
    {
        view.endEditing(true)
    }
    @objc func weightButtonPressed (sender: UIButton)
    {
        customEntryTF.isHidden = true
        EYWGLabel.isHidden = true
        
        entryTF.isHidden = false
        EYWLabel.isHidden = false
        kgOrLbs.isHidden = false
        okBackToVC.isHidden = false
    }
    @objc func customButtonPressed (sender: UIButton)
    {
        entryTF.isHidden = true
        EYWLabel.isHidden = true
        kgOrLbs.isHidden = true
        
        customEntryTF.isHidden = false
        EYWGLabel.isHidden = false
        okBackToVC.isHidden = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        numOunces = Double((textField.text)!)!
        
        if textField == entryTF
        {
            if kgOrLbs.selectedSegmentIndex == 1
            {
                numOunces! /= 2
            }
            yourWaterGoal.text = "You should drink \(numOunces ?? 0.0) ounces of water per day."
        }
        yourWaterGoal.text = "Your goal is to drink \(numOunces ?? 0.0) ounces of water per day."
        yourWaterGoal.sizeToFit()
        yourWaterGoal.isHidden = false
        defaults.set(numOunces, forKey: "Goal")
    }
    @objc func massUnitsSwitched (sender: UISegmentedControl)
    {
        textFieldDidEndEditing(entryTF)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
    }
}
