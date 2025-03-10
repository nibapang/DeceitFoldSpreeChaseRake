//
//  CardGameVC.swift
//  DeceitFoldSpreeChaseRake
//
//  Created by DeceitFoldSpree ChaseRake on 2025/3/10.
//


import UIKit

class ChaseRakeCardGameVC: UIViewController {
    
    //MARK: - Declare IBOutlets
    @IBOutlet weak var cardWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sequenceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    //MARK: - Declare Variables
    let cardValues = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    let suits = ["♠️", "♣️", "♦️", "♥️"]
    var cards: [String] = []
    var sequence: [String] = []
    var selectedSequence: [String] = []
    var score = 0
    var timer: Timer?
    var timeLeft = 180
    var selectedCardIndices: [IndexPath] = []
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let generatedCards = generateDeck()
        cards = generatedCards.shuffled()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        startNewRound()
        startTimer()
    }
    
    //MARK: - Functions
    func generateDeck() -> [String] {
        var deck: [String] = []
        for suit in suits {
            for value in cardValues {
                deck.append("\(value)\(suit)")
            }
        }
        return deck
    }
    
    func startNewRound() {
        sequence = (0..<Int.random(in: 3...6)).map { _ in cards.randomElement()! }
        sequenceLabel.text = sequence.joined(separator: " ")
        selectedSequence = []
        
        // Reset selections
        selectedCardIndices.removeAll()
        collectionView.reloadData()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.timeLeft -= 1
            self.timerLabel.text = "\(self.timeLeft)s"
            if self.timeLeft <= 0 {
                self.endGame()
            }
        }
    }
    
    func endGame() {
        timer?.invalidate()
        let highScore = UserDefaults.standard.integer(forKey: "HighScore")
        if score > highScore {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        showAlert(title: "Game Over", message: "Your score: \(score)\nHigh Score: \(highScore)")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true)
    }
    
    func resetGame() {
        score = 0
        timeLeft = 180
        scoreLabel.text = "Score: 0"
        
        // Reset selections
        selectedCardIndices.removeAll()
        collectionView.reloadData()
        
        startNewRound()
        startTimer()
    }
    
    //MARK: - Declare IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Datasource and Delegate Methods
extension ChaseRakeCardGameVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! ChaseRakeCardCell
        cell.cardLabel.image = UIImage(named: cards[indexPath.row])
        
        // Maintain selection state
        cell.setSelected(selectedCardIndices.contains(indexPath))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedCard = cards[indexPath.row]
            let cell = collectionView.cellForItem(at: indexPath) as? ChaseRakeCardCell

            if selectedCard == sequence[selectedSequence.count] {
                selectedSequence.append(selectedCard)
                selectedCardIndices.append(indexPath)
                cell?.setSelected(true)
                
                if selectedSequence == sequence {
                    score += 10
                    scoreLabel.text = "\(score)"
                    startNewRound()
                }
            } else {
                showAlert(title: "Wrong!", message: "Try again.")
                timer?.invalidate()
            }
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cvHeight = collectionView.frame.size.height / 4 - 3
        cardWidth.constant = (cvHeight / 1.2224137931 + 3) * 13
        return CGSize(width: cvHeight / 1.2224137931, height: cvHeight)
    }
    
    
}
