//
//  ViewController.swift
//  NapClock
//
//  Created by Raymond Sarinas on 2018-01-07.
//  Copyright © 2018 Raymond Sarinas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NEED TO REMOVE SECONDS
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.time
        datePicker.addTarget(self, action: #selector(ViewController.timePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        timeTextField.inputView = datePicker
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func timePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.none // don't show the date
        formatter.timeStyle = DateFormatter.Style.short
        timeTextField.text = formatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func computeSuggestion(sender: UIButton) {
        
        let text: String = timeTextField.text!
        let timeArr = Array(text)
        var convention = timeArr[5]
        
        var hour1 = Int("\(timeArr[0])")! - 6
        var min = "0"
        
        if hour1 == 0 {
            hour1 = 12
        }
        
        if timeArr[1] != ":" {
            hour1 += 6
            hour1 = (hour1 * 10) + Int("\(timeArr[1])")! - 6
            
            min = String((Int("\(timeArr[3])")! * 10) + Int("\(timeArr[4])")!)
        }
        else {
            min = String((Int("\(timeArr[2])")! * 10) + Int("\(timeArr[3])")!)
        }
        
        
        if Int(min)! < 10 {
            min = "0\(min)"
        }
        
        if hour1 > 12 {
            switch convention {
            case "P":
                convention = "A"
                break
            case "A":
                convention = "P"
                break
            case " ":
                convention = timeArr[6]
                switch convention { // there is probably a better way to do this
                case "P":
                    convention = "A"
                    break
                case "A":
                    convention = "P"
                    break
                default:
                    break
                }
            default:
                break
            }
            
            hour1 -= 12
        }
        
        if hour1 < 0 {
            
            switch convention {
            case "P":
                convention = "A"
                break
            case "A":
                convention = "P"
                break
            case " ":
                convention = timeArr[6]
                switch convention { // there is probably a better way to do this
                case "P":
                    convention = "A"
                    break
                case "A":
                    convention = "P"
                    break
                case " ":
                    convention = timeArr[7]
                    switch convention { // there is probably a better way to do this
                    case "P":
                        convention = "A"
                        break
                    case "A":
                        convention = "P"
                        break
                    default:
                        break
                    }
                default:
                    break
                }
            default:
                break
            }
            
            hour1 += 12
        }
        
        if hour1 > 0 && hour1 <= 12 {
            if convention == " " {
                convention = timeArr[6]
            }
        }
        
        
        let suggestionString = "\(hour1):\(min) \(convention)M"
        
        let alertController = UIAlertController(title: "You should go to bed at:", message: "\(suggestionString)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    // "What time should I wake up if I go to bed now?"
    @IBAction func showMessage(sender: UIButton) {
        
        var components = DateComponents()
        components.setValue(360, for: .minute)
        let date: Date = Date()
        let expirationDate = Calendar.current.date(byAdding: components, to: date)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let output = dateFormatter.string(from: expirationDate!)
        
        let alertController = UIAlertController(title: "You should wake up at: ", message: "\(output)", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}

