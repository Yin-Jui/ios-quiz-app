//
//  DetailViewController.swift
//  Exercise1
//
//  Created by 廖胤瑞 on 2020/11/23.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @IBOutlet var Question: UITextField!
    @IBOutlet var Answer: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    // to see if it is a view for adding a mew question
    var isAdd: Bool = false
    var hasAdded: Bool = false
    var question: Question!
    var imageStore: ImageStore!
    
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        //if UIImagePickerController.isSourceTypeAvailable(.camera) {
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            let imagePicker = self.imagePicker(for: .camera)
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        // }
        
        let photoLibraryAction
            = UIAlertAction(title: "Photo Library", style: .default) { _ in
                let imagePicker = self.imagePicker(for: .photoLibrary)
                imagePicker.modalPresentationStyle = .popover
                imagePicker.popoverPresentationController?.barButtonItem = sender
                self.present(imagePicker, animated: true, completion: nil)
            }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePicker(for sourceType: UIImagePickerController.SourceType)
    -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        // Get picked image from info dictionary
        let image = info[.originalImage] as! UIImage
        
        if(!isAdd){
            imageStore.setImage(image, forKey: question.itemKey)
        }
        // If it is a new question, need to create a new question first to add its image.
        else{
            let q = Question.text ?? ""
            let tmp = QuestionViewController()
            if let valueText = Answer.text,
               let value = numberFormatter.number(from: valueText) {
                tmp.addNewQuestion(q: q, a: value.intValue)
            } else {
                tmp.addNewQuestion(q: q, a: 0)
            }
            let question = shared.info.questionList[shared.info.questionList.count-1]
            imageStore.setImage(image, forKey: question.itemKey)
            hasAdded = true;
        }
        // Put that image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen - you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!isAdd){
            Question.text = question.question
            Answer.text = String(question.answer)
            dateLabel.text = dateFormatter.string(from: question.dateCreated)
            let key = question.itemKey
            let imageToDisplay = imageStore.image(forKey: key)
            imageView.image = imageToDisplay
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        if(!isAdd){
            question.question = Question.text ?? ""
            if let valueText = Answer.text,
               let value = numberFormatter.number(from: valueText) {
                question.answer = value.intValue
            } else {
                question.answer = 0
            }
        }
        //if it has not been created when selecting the image.
        else if(!hasAdded){
            let q = Question.text ?? ""
            let tmp = QuestionViewController()
            if let valueText = Answer.text,
               let value = numberFormatter.number(from: valueText) {
                tmp.addNewQuestion(q: q, a: value.intValue)
            } else {
                tmp.addNewQuestion(q: q, a: 0)
            }
        }
    }
    //This method is called whenever the Return key is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
