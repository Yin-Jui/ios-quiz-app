//
//  Question.swift
//  Exercise1
//
//  Created by 廖胤瑞 on 2020/11/21.
//

import UIKit

class Question: Equatable, Codable{
    
    static func ==(q1: Question, q2: Question) -> Bool {
           return q1.question == q2.question
       }
    var question: String
    var answer: Int
    let dateCreated: Date
    let itemKey: String
    var isSubmitted: Bool
    
    init(q: String, a: Int) {
        self.question = q
        self.answer = a
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        self.isSubmitted = false
    }
}
