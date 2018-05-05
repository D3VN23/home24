//
//  SelectionPresenter.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/1/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import Foundation

protocol ArticleSelectionView: NSObjectProtocol, ActivityIndicatorProtocol {
    func show(article: ArticleViewData)
    func updateLikeCounter(with value: String)
    func showNoMoreArticlesMessage()
}

class ArticleSelectionPresenter{
    
    //MARK: - Properties
    var articlesViewData = [ArticleViewData]()
    
    //MARK: - Private Properties
    fileprivate let articleSelectionService: ArticleSelectionService
    fileprivate var articleIds = [String]()
    fileprivate var currentArticleIndex = 0
    fileprivate var articleSelectionRouter: ArticleSelectioRouter
    weak fileprivate var articleSelectionView: ArticleSelectionView?
    
    //MARK: - Initializers
    init(articleSelectionService: ArticleSelectionService, articleSelectionRouter: ArticleSelectioRouter) {
        self.articleSelectionService = articleSelectionService
        self.articleSelectionRouter = articleSelectionRouter
        self.initializeArticleIds()
    }
    
    func initializeArticleIds() {
        for i in 0..<Project.articlesCount {
            self.articleIds.append("00000000" + "\(1000008788 + i)")
        }
    }
    
    //MARK: - View Lifecycle
    func attachView(_ view: ArticleSelectionView) {
        self.articleSelectionView = view
    }
    
    func detachView() {
        self.articleSelectionView = nil
    }
    
    //MARK: - Business Logic
    func loadArticles() {
        self.articleSelectionView?.startLoading()
        self.articleSelectionService.getArticles(for: self.articleIds) { [weak self] articles, error in
            self?.articleSelectionView?.finishLoading()
            if let articles = articles {
                self?.articlesViewData = articles.map { article in
                    return ArticleViewData(image: URL(string: article.media[0].uri)!, title: article.title, liked: false)
                }
            }
            self?.updateLikesCounter()
            self?.showNextArticle()
        }
    }
    
    func showNextArticle() {
        if self.articlesViewData.count == self.currentArticleIndex {
            self.articleSelectionView?.showNoMoreArticlesMessage()
            return
        }
        let article = self.articlesViewData[self.currentArticleIndex]
        self.articleSelectionView?.show(article: article)
    }
    
    func setLike(for value: Bool) {
        self.articlesViewData[self.currentArticleIndex].liked = value
        self.updateLikesCounter()
        self.currentArticleIndex += 1
        self.showNextArticle()
    }
    
    func updateLikesCounter() {
        let likesCount = self.articlesViewData.reduce(0) { $1.liked == true ? $0 + 1 : $0 }
        self.articleSelectionView?.updateLikeCounter(with: "\(likesCount)/\(self.articlesViewData.count)")
    }
    
    func openReviews() {
        self.articleSelectionRouter.openReview(for: self.articlesViewData)
    }
}
