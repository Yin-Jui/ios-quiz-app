//
//  shared.swift
//  Exercise1
//
//  Created by 廖胤瑞 on 2020/11/19.
//

import UIKit

class shared {
    //URL for saving the instances of Question
    let itemArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    static let info = shared()
    var correct = 0
    var incorrect = 0
    var currentIndex = 0
    var questionList = [Question]()
    var answers: [Int] = [
        14,
        72,
        16
    ]
    private init() {
        //load the items
        do {
                let data = try Data(contentsOf: itemArchiveURL)
                let unarchiver = PropertyListDecoder()
                let questions = try unarchiver.decode([Question].self, from: data)
                questionList = questions
            } catch {
                print("Error reading in saved items: \(error)")
            }
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(saveChanges),
                                           name: UIScene.didEnterBackgroundNotification,
                                           object: nil)
    }
    @discardableResult func creatQuestion(q:String, a:Int) -> Question {
        let newQuestion = Question(q: q, a: a)
            questionList.append(newQuestion)
            return newQuestion
        }
    func createQuestions(){
        let newQuestion = Question(q: "5 + 9 = ?", a: 14)
            questionList.append(newQuestion)
        let newQuestion2 = Question(q: "9 * 8 = ?", a: 72)
            questionList.append(newQuestion2)
        let newQuestion3 = Question(q: "90 / 5 = ?", a: 16)
            questionList.append(newQuestion3)
    }
    func removeQuestion(_ question: Question) {
        if let index = questionList.firstIndex(of: question) {
            questionList.remove(at: index)
            answers.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let movedItem = questionList[fromIndex]
        questionList.remove(at: fromIndex)
        questionList.insert(movedItem, at: toIndex)
        //update the index of answers array
        let movedAnswer = answers[fromIndex]
        answers.remove(at: fromIndex)
        answers.insert(movedAnswer, at: toIndex)
    }
    
    @objc func saveChanges() -> Bool {

        do{
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(questionList)
            try data.write(to: itemArchiveURL, options: [.atomic])
                    print("Saved all of the items")
                    print(itemArchiveURL)
                    return true
                } catch let encodingError {
                    print("Error encoding allItems: \(encodingError)")
                    return false
                }

    }
}
