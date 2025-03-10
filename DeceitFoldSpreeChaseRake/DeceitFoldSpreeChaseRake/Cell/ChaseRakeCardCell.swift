//
//  CardCell.swift
//  DeceitFoldSpreeChaseRake
//
//  Created by DeceitFoldSpree ChaseRake on 2025/3/10.
//

import UIKit

class ChaseRakeCardCell: UICollectionViewCell {
    @IBOutlet weak var cardLabel: UIImageView!
    
    func setSelected(_ isSelected: Bool) {
        self.layer.borderWidth = isSelected ? 3 : 0
        self.layer.borderColor = isSelected ? UIColor.yellow.cgColor : nil
        self.layer.cornerRadius = 8
    }
}
