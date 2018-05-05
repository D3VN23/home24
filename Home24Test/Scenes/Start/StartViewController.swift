//
//  StartViewController.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/5/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    //MARK: - Actions
    @IBAction func openArticleSelection(_ sender: UIButton) {
        Animator.performBounceAnimation(for: sender)
        self.navigationController?.pushViewController(Storyboard.main.instantiateViewController(withIdentifier: ViewControllerIdentifier.articleSelection), animated: true)
    }
}
