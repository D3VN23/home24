//
//  ArticlesSelectionRouter.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/5/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import Foundation

protocol ArticleSelectionViewRouter {
    func openReview(for articles: [ArticleViewData])
}

class ArticleSelectioRouter: ArticleSelectionViewRouter {
    
    //MARK: - Private Properties
    fileprivate weak var articleSelectionViewController: ArticleSelectionViewController?
    
    //MARK: - Initializers
    init(articleSelectionViewController: ArticleSelectionViewController) {
        self.articleSelectionViewController = articleSelectionViewController
    }
    
    //MARK: - View Router
    func openReview(for articles: [ArticleViewData]) {
        let articleReviewViewController = Storyboard.main.instantiateViewController(withIdentifier: ViewControllerIdentifier.articleReview) as! ArticleReviewViewController
        articleReviewViewController.articles = articles
        DispatchQueue.main.async {
            self.articleSelectionViewController?.navigationController?.pushViewController(articleReviewViewController, animated: true)
        }
    }
}
