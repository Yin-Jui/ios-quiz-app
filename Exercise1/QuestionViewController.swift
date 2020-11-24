//
//  QuestionViewController.swift
//  Exercise1
//
//  Created by 廖胤瑞 on 2020/11/20.
//

import UIKit

class QuestionViewController: UITableViewController {
    
    let imageStore = ImageStore()
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = editButtonItem
        super.viewDidLoad()
        tableView.rowHeight = 65
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    //total row
    override func tableView(_ tableView: UITableView,
            numberOfRowsInSection section: Int) -> Int {
        return shared.info.questionList.count
    }
    //content of the row
    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        let question = shared.info.questionList[indexPath.row]
        cell.questionLabel.text = question.question
        cell.answerLabel.text = String(question.answer)
        return cell
    }
    
    
    //delete row
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let question = shared.info.questionList[indexPath.row]
            // Remove the item from the store
            shared.info.removeQuestion(question)
            // Remove the item's image from the image store
            imageStore.deleteImage(forKey: question.itemKey)
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        
        shared.info.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showQuestion":
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let question = shared.info.questionList[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.question = question
                detailViewController.imageStore = imageStore
            }
        case "addQuestion":
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.isAdd = true
            detailViewController.imageStore = imageStore
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func addNewQuestion(q: String, a: Int){
        
        let newQuestion = shared.info.creatQuestion(q: q, a: a)
        if let index = shared.info.questionList.firstIndex(of: newQuestion) {

            let indexPath = IndexPath(row: index, section: 0)
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

}
