//
//  HowToPlayViewController.swift
//  DeceitFoldSpreeChaseRake
//
//  Created by DeceitFoldSpree ChaseRake on 2025/3/10.
//


import UIKit

class ChaseRakeHowToPlayVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let steps: [(title: String, description: String)] = [
        ("Objective", "Fill the 5x5 grid with cards while following the Cascade Rule."),
        ("Starting the Game", "You start with a random card placed on the grid."),
        ("Drawing Cards", "Each turn, you draw a random card (1-5) to place on the board."),
        ("Placing Cards", "You must place the drawn card adjacent to an existing card."),
        ("Cascade Rule", "The new card must be equal to, one higher, or one lower than an adjacent card."),
        ("Scoring", "You gain points for each valid placement. Try to fill the board!"),
        ("Undo", "You have limited undos to fix mistakes."),
        ("Game Over", "The game ends when no valid moves remain."),
        ("Winning", "If you fill all 25 spaces, you win!")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as! ChaseRakeStepCell
        cell.lblTitle.text = steps[indexPath.row].title
        cell.lblDesc.text = steps[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
