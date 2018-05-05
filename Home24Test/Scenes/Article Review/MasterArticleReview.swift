//
//  ArticleReviewViewController.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/1/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import UIKit

class ArticleReviewViewController: UIViewController {
    
    //MARK: - Public Properties
    var articles = [ArticleViewData]()
    
    //MARK: - Private Properties
    fileprivate var articleReviewPresenter = ArticleReviewPresenter()
    
    //MARK: - UI
    @IBOutlet weak var reviewTypeControll: UISegmentedControl!
    
    @IBOutlet weak var listReviewContainerView: UIView!
    @IBOutlet weak var gridReviewContainerView: UIView!
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Container Dependencies
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.articleReviewPresenter.prepare(for: segue, sender: sender, with: self.articles)
    }
    
    //MARK: - Actions
    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchReviewType(_ sender: UISegmentedControl) {
        switch reviewTypeControll.selectedSegmentIndex {
        case 0:
            self.listReviewContainerView.isHidden = false
            self.gridReviewContainerView.isHidden = true
        default:
            self.listReviewContainerView.isHidden = true
            self.gridReviewContainerView.isHidden = false
        }
    }
}

//MARK: - Presenter
class ArticleReviewPresenter {
    
    init() {}
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?, with articles: [ArticleViewData]) {
        if segue.identifier == "listReviewSegue" {
            let listReviewViewController = segue.destination as? ListReviewViewController
            listReviewViewController?.articles = articles
        }
        if segue.identifier == "gridReviewSegue" {
            let gridReviewViewController = segue.destination as? GridReviewViewController
            gridReviewViewController?.articles = articles
        }
    }
}
