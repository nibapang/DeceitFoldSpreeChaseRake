//
//  CardCascadeViewController.swift
//  DeceitFoldSpreeChaseRake
//
//  Created by DeceitFoldSpree ChaseRake on 2025/3/10.
//


import UIKit

class CardCascadeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var drawCardLabel: UILabel!
    @IBOutlet weak var undoButton: UIButton!
    
    let gridSize = 5
    var grid: [[Int?]] = []
    var drawCard: Int = 1
    var score = 0
    var lastMove: (row: Int, col: Int, previousValue: Int?)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupGame()
    }
    
    func setupGame() {
        grid = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
        drawCard = 1
        score = 0
        lastMove = nil
        
        placeStartingCard()
        drawNewCard()
        ensureValidMoveExists()
        updateUI()
    }

    func placeStartingCard() {
        let startRow = Int.random(in: 0..<gridSize)
        let startCol = Int.random(in: 0..<gridSize)
        grid[startRow][startCol] = Int.random(in: 1...5)
    }
    
    func drawNewCard() {
        drawCard = Int.random(in: 1...5)
        drawCardLabel.text = "\(drawCard)♠️"
    }
    
    func updateUI() {
        collectionView.reloadData()
        scoreLabel.text = "\(score)"
    }
    
    func isValidMove(row: Int, col: Int) -> Bool {
        guard grid[row][col] == nil else { return false }
        
        let adjacentOffsets = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        for (dx, dy) in adjacentOffsets {
            let newRow = row + dx
            let newCol = col + dy
            if newRow >= 0, newRow < gridSize, newCol >= 0, newCol < gridSize, let adjacentValue = grid[newRow][newCol] {
                if drawCard == adjacentValue || drawCard == adjacentValue + 1 || drawCard == adjacentValue - 1 {
                    return true
                }
            }
        }
        return false
    }

    func ensureValidMoveExists() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if isValidMove(row: row, col: col) {
                    return
                }
            }
        }
        shownoValidMoveAlert() // Restart if no valid moves are available
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func undoLastMove(_ sender: UIButton) {
        if let lastMove = lastMove {
            grid[lastMove.row][lastMove.col] = lastMove.previousValue
            score -= 1
            updateUI()
        }
    }
    
    func shownoValidMoveAlert() {
        let alert = UIAlertController(title: "No More Move Left", message: "Final Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.setupGame()
        }))
        present(alert, animated: true)
    }
    
    func showGameOver() {
        let alert = UIAlertController(title: "Game Over", message: "Final Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.setupGame()
        }))
        present(alert, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridSize * gridSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell1", for: indexPath) as! CardCell1
        let row = indexPath.item / gridSize
        let col = indexPath.item % gridSize
        let value = grid[row][col]
        cell.configure(with: value)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.item / gridSize
        let col = indexPath.item % gridSize
        
        if grid[row][col] == nil && isValidMove(row: row, col: col) {
            lastMove = (row, col, grid[row][col])
            grid[row][col] = drawCard
            score += 1
            drawNewCard()
            ensureValidMoveExists()
            updateUI()
            checkGameOver()
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? CardCell1 {
                cell.shake()
            }
        }
    }

    func checkGameOver() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] == nil && isValidMove(row: row, col: col) {
                    return
                }
            }
        }
        showGameOver()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 5, height: collectionView.frame.size.height / 5)
    }
}

class CardCell1: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UIImageView!
    
    func configure(with value: Int?) {
        if let value = value {
            numberLabel.image = UIImage(named: "\(value)")
            backgroundColor = .systemBlue
        } else {
            numberLabel.image = UIImage(named: "")
            backgroundColor = .lightGray
        }
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
}
