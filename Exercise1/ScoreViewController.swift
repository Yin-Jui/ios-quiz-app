//
//  ScoreViewController.swift
//  Exercise1
//
//  Created by 廖胤瑞 on 2020/11/19.
//

import UIKit

class ScoreViewController: UIViewController{
    
    @IBOutlet var background: UIView!
    @IBOutlet var score: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        let diff: Int = shared.info.correct - shared.info.incorrect
        if(diff > 0){
            score.text = String(diff * 10)
            background.backgroundColor = UIColor.green
        }
        else if(diff == 0){
            score.text = String(0);
            background.backgroundColor = UIColor.white
        }
        else{
            score.text = String(diff * 10);
            background.backgroundColor = UIColor.red
        }
    }
}
