//
//  ViewController.swift
//  Exercise1
//
//  Created by 廖胤瑞 on 2020/11/19.
//

import UIKit

class MultiChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var submit: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    var currentIndex: Int = 0
    var options: [[String]] = [["Sydney", "Perth", "Brisbane", "Melbourne"], ["Ping An Finance Center", "Abraj Al-Bait Clock Tower", "Shanghai Tower", "Burj Khalifa"], ["1918", "1937", "1914", "2020"]]
    var choice: String = ""
    let questions: [String] = [
            "What is the capital city of Australia?",
            "What is the tallest building in the world",
            "When did the World War 1 happen?"
        ]
    let answers: [String] = [
        "Melbourne",
        "Burj Khalifa",
        "1914"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        questionLabel.text = questions[currentIndex]
        resultLabel.text = "";
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return options[currentIndex].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[currentIndex][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choice = options[currentIndex][row]
        print(choice)
    }
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentIndex += 1
        resultLabel.text = ""
        if currentIndex+1 == questions.count{
            nextButton.isEnabled = false
        }
        let question: String = questions[currentIndex]
        questionLabel.text = question
        submit.isEnabled = true
        //set default choice
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.reloadAllComponents()
    }
   
    @IBAction func submitAnswer(_ sender: UIButton){
        if choice == answers[currentIndex]{
            shared.info.correct += 1
            resultLabel.text = "Correct"
            resultLabel.textColor = UIColor.green
        }
        else{
            shared.info.incorrect += 1
            resultLabel.text = "Incorrect"
            resultLabel.textColor = UIColor.red
        }
        submit.isEnabled = false
    }
}

