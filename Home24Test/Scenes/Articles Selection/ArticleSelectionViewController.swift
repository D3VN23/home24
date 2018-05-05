//
//  SelectionViewController.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/1/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import UIKit
import SVProgressHUD
import AlamofireImage

class ArticleSelectionViewController: UIViewController {
    
    //MARK: - Private Properties
    fileprivate var articleSelectionPresenter: ArticleSelectionPresenter!
    
    //MARK: - UI
    @IBOutlet weak var likedArticlesLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    
    @IBOutlet weak var noMoreArticlesLabel: UILabel!
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializePresenter()
    }
    
    //MARK: - Initializers
    func initializePresenter() {
        self.articleSelectionPresenter = ArticleSelectionPresenter(articleSelectionService: ArticleSelectionService(), articleSelectionRouter: ArticleSelectioRouter(articleSelectionViewController: self))
        self.articleSelectionPresenter.attachView(self)
        self.articleSelectionPresenter.loadArticles()
    }
    
    //MARK: - Action Handlers
    @IBAction func likeArticle(_ sender: UIButton) {
        Animator.performBounceAnimation(for: sender)
        self.articleSelectionPresenter.setLike(for: true)
        self.articleImageView.image = nil
    }
    
    @IBAction func dislikeArticle(_ sender: UIButton) {
        Animator.performBounceAnimation(for: sender)
        self.articleSelectionPresenter.setLike(for: false)
        self.articleImageView.image = nil
    }
    
    @IBAction func openReviews(_ sender: Any) {
        self.articleSelectionPresenter.openReviews()
    }
    
    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - View
extension ArticleSelectionViewController: ArticleSelectionView {
    
    func showNoMoreArticlesMessage() {
        DispatchQueue.main.async {
            self.articleImageView.isHidden = true
            self.articleTitleLabel.isHidden = true
            self.likeButton.isEnabled = false
            self.dislikeButton.isEnabled = false
            self.reviewButton.isEnabled = true
        }
    }
    
    func updateLikeCounter(with value: String) {
        DispatchQueue.main.async {
            self.likedArticlesLabel.text = value
        }
    }
    
    func show(article: ArticleViewData) {
        DispatchQueue.main.async {
            self.articleTitleLabel.text = article.title
            self.articleImageView.af_setImage(withURL: article.image, imageTransition: .crossDissolve(0.3))
        }
    }
    
    func startLoading() {
        SVProgressHUD.show()
    }
    
    func finishLoading() {
        SVProgressHUD.dismiss()
    }
}
