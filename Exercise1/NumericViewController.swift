//
//  NumericViewController.swift
//  Exercise1
//
//  Created by 廖胤瑞 on 2020/11/19.
//

import UIKit

class NumericViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var input: UITextField!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var submit: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    var ans: Int? // users might not input the answer yet
    
    //Update if there is modification of question list
    override func viewWillAppear(_ animated: Bool) {
        print(shared.info.questionList)
        if(shared.info.currentIndex == shared.info.questionList.count - 1){
            questionLabel.text = shared.info.questionList[shared.info.currentIndex].question
            let key = shared.info.questionList[shared.info.currentIndex].itemKey
            let imageStore = ImageStore()
            imageView.image = imageStore.image(forKey: key)
            nextButton.isEnabled = false
            if(!shared.info.questionList[shared.info.currentIndex].isSubmitted){
                submit.isEnabled = true
            }
            input.isEnabled = true
        }
        else if(shared.info.currentIndex == shared.info.questionList.count){
            questionLabel.text = "No more question to display"
            submit.isEnabled = false
            nextButton.isEnabled = false
            input.isEnabled = false
            return
        }
        else{
            if(!shared.info.questionList[shared.info.currentIndex].isSubmitted){
                submit.isEnabled = true
            }
            questionLabel.text = shared.info.questionList[shared.info.currentIndex].question
            let key = shared.info.questionList[shared.info.currentIndex].itemKey
            let imageStore = ImageStore()
            imageView.image = imageStore.image(forKey: key)
            resultLabel.text = ""
            nextButton.isEnabled = true
            input.isEnabled = true
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(shared.info.questionList.count == 0){
            questionLabel.text = ""
        }
        else{
            questionLabel.text = shared.info.questionList[shared.info.currentIndex].question
        }
        resultLabel.text = ""
    }
    @IBAction func inputChanged(_ textField: UITextField) {
        if let text = textField.text,
           let value = Int(text){
            ans = value
        }
        else{
            ans = nil
        }
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        input.resignFirstResponder()
    }
    //same as muti choice view
    @IBAction func showNextQuestion(_ sender: UIButton) {
        shared.info.currentIndex += 1
        resultLabel.text = ""
        if shared.info.currentIndex+1 == shared.info.questionList.count{
            nextButton.isEnabled = false
        }
        let question: String = shared.info.questionList[shared.info.currentIndex].question
        questionLabel.text = question
        let key = shared.info.questionList[shared.info.currentIndex].itemKey
        let imageStore = ImageStore()
        imageView.image = imageStore.image(forKey: key)
        submit.isEnabled = true
        input.text = ""
    }
    //same as muti choice view
    @IBAction func submitAnswer(_ sender: UIButton){
        if ans == shared.info.questionList[shared.info.currentIndex].answer{
            shared.info.correct += 1
            resultLabel.text = "Correct"
            resultLabel.textColor = UIColor.green
        }
        else{
            shared.info.incorrect += 1
            resultLabel.text = "Incorrect"
            resultLabel.textColor = UIColor.red
        }
        shared.info.questionList[shared.info.currentIndex].isSubmitted = true
        submit.isEnabled = false
        input.text = ""
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn:"-0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        return allowedCharacters.isSuperset(of: characterSet) && !(existingTextHasDecimalSeparator != nil &&
                                                                    replacementTextHasDecimalSeparator != nil)
    }
}


