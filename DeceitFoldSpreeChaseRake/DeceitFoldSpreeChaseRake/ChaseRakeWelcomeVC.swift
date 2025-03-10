//
//  WelcomeVC.swift
//  DeceitFoldSpreeChaseRake
//
//  Created by jin fu on 2025/3/10.
//


import UIKit

class ChaseRakeWelcomeVC: UIViewController {

    //MARK: - Declare IBOutlets
    
    @IBOutlet weak var contentView: UIStackView!
    
    //MARK: - Declare Variables
    
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            self.contentView.axis = .horizontal
        } else {
            self.contentView.axis = .vertical
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                self.contentView.axis = .horizontal
            } else {
                self.contentView.axis = .vertical
            }
        }, completion: nil)
    }
    
    //MARK: - Functions
    
    
    //MARK: - Declare IBAction
    
}
