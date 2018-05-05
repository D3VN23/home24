//
//  Home24TestTests.swift
//  Home24TestTests
//
//  Created by Alexander Lisovik on 5/1/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import XCTest
@testable import Home24Test

class ArticleSelectionServiceMock: ArticleSelectionService {
    fileprivate let articles: [Article]
    
    init(articles: [Article]) {
        self.articles = articles
    }
    
    override func getArticles(for articlesIds: [String], callBack: @escaping ([Article]?, Error?) -> Void) {
        callBack(self.articles, nil)
    }
}

class ArticleSelectionViewMock: NSObject, ArticleSelectionView {
    
    var likeCounterString = String()
    var nextArticle = ArticleViewData(image: URL(string: "uri")!, title: "Esszimmerstuhl Manchester (2er-Set) - Akazie massiv", liked: false)
    var noMoreArticlesWasShowed = false
    
    func startLoading() {}
    func finishLoading() {}
    
    func show(article: ArticleViewData) {
        self.nextArticle = article
    }
    
    func updateLikeCounter(with value: String) {
        self.likeCounterString = value
    }
    
    func showNoMoreArticlesMessage() {
        self.noMoreArticlesWasShowed = true
    }
}

class ArticleSelectionPresenterTests: XCTestCase {
    
    var articlesServiceMock: ArticleSelectionServiceMock!
    var articlesViewDataMock: [ArticleViewData]!
    let articlesJson = """
        [{
            "sku": "001",
            "title": "Esszimmerstuhl Manchester (2er-Set) - Akazie massiv",
            "media": [{"uri": "uri"}]
        },
        {
            "sku": "002",
            "title": "Esszimmerstuhl Ohio (2er-Set) - Sheesham massiv - gewachst",
            "media": [{"uri": "uri"}]
        },
        {
            "sku": "003",
            "title": "Barhocker Atelier (2er-Set) - Akazie massiv / Metall",
            "media": [{"uri": "uri"}]
        },
        {
            "sku": "004",
            "title": "Bar Atelier - Akazie teilmassiv",
            "media": [{"uri": "uri"}]
        },
        {
            "sku": "005",
            "title": "Bartisch Beton - Akazie teilmassiv / Beton Dekor - Akazie",
            "media": [{"uri": "uri"}]
        }]
    """
    
    override func setUp() {
        super.setUp()
        let jsonDecoder = JSONDecoder()
        do {
            let articles = try jsonDecoder.decode([Article].self, from: self.articlesJson.data(using: .utf8)!)
            self.articlesServiceMock = ArticleSelectionServiceMock(articles: articles)
            self.articlesViewDataMock = articles.map { article in
                return ArticleViewData(image: URL(string: article.media[0].uri)!, title: article.title, liked: false)
            }
        } catch {
            XCTAssert(false)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLikesSetterWorksCorrectly() {
        
        let articleSelectionPresenterTest = ArticleSelectionPresenter(articleSelectionService: self.articlesServiceMock, articleSelectionRouter: ArticleSelectioRouter(articleSelectionViewController: ArticleSelectionViewController()))
        let expectedResult = [true, true, true, false, false]
        var actualResult = articleSelectionPresenterTest.articlesViewData.map { article in
            return article.liked
        }
        
        articleSelectionPresenterTest.loadArticles()
        
        XCTAssertNotEqual(expectedResult, actualResult)
        
        articleSelectionPresenterTest.setLike(for: true)
        articleSelectionPresenterTest.setLike(for: true)
        articleSelectionPresenterTest.setLike(for: true)
        articleSelectionPresenterTest.setLike(for: false)
        articleSelectionPresenterTest.setLike(for: false)
        
        actualResult = articleSelectionPresenterTest.articlesViewData.map { article in
            return article.liked
        }
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testLikesCounterLabelUpdatingCorrecly() {
        
        let articleSelectionViewMock = ArticleSelectionViewMock()
        let articleSelectionPresenterTest = ArticleSelectionPresenter(articleSelectionService: self.articlesServiceMock, articleSelectionRouter: ArticleSelectioRouter(articleSelectionViewController: ArticleSelectionViewController()))
        articleSelectionPresenterTest.attachView(articleSelectionViewMock)
        
        articleSelectionPresenterTest.loadArticles()
        
        articleSelectionPresenterTest.setLike(for: true)
        var expectedResult = "1/5"
        XCTAssertEqual(expectedResult, articleSelectionViewMock.likeCounterString)
        articleSelectionPresenterTest.setLike(for: true)
        expectedResult = "2/5"
        XCTAssertEqual(expectedResult, articleSelectionViewMock.likeCounterString)
        articleSelectionPresenterTest.setLike(for: true)
        expectedResult = "3/5"
        XCTAssertEqual(expectedResult, articleSelectionViewMock.likeCounterString)
        articleSelectionPresenterTest.setLike(for: false)
        expectedResult = "3/5"
        XCTAssertEqual(expectedResult, articleSelectionViewMock.likeCounterString)
        articleSelectionPresenterTest.setLike(for: false)
        expectedResult = "3/5"
        
        XCTAssertEqual(expectedResult, articleSelectionViewMock.likeCounterString)
    }
    
    func testNoMoreArticlesMessageWillBeShowedCorrectly() {
        
        let articleSelectionViewMock = ArticleSelectionViewMock()
        let articleSelectionPresenterTest = ArticleSelectionPresenter(articleSelectionService: self.articlesServiceMock, articleSelectionRouter: ArticleSelectioRouter(articleSelectionViewController: ArticleSelectionViewController()))
        articleSelectionPresenterTest.attachView(articleSelectionViewMock)
        
        articleSelectionPresenterTest.loadArticles()
        
        XCTAssertEqual(false, articleSelectionViewMock.noMoreArticlesWasShowed)
        
        articleSelectionPresenterTest.setLike(for: true)
        articleSelectionPresenterTest.setLike(for: true)
        articleSelectionPresenterTest.setLike(for: true)
        articleSelectionPresenterTest.setLike(for: false)
        articleSelectionPresenterTest.setLike(for: false)
        
        XCTAssertEqual(true, articleSelectionViewMock.noMoreArticlesWasShowed)
    }
    
    func testNextArticleToShowIsCorrect() {
        let articleSelectionViewMock = ArticleSelectionViewMock()
        let articleSelectionPresenterTest = ArticleSelectionPresenter(articleSelectionService: self.articlesServiceMock, articleSelectionRouter: ArticleSelectioRouter(articleSelectionViewController: ArticleSelectionViewController()))
        articleSelectionPresenterTest.attachView(articleSelectionViewMock)
        
        articleSelectionPresenterTest.loadArticles()
        
        XCTAssertEqual(self.articlesViewDataMock[0], articleSelectionViewMock.nextArticle)
        articleSelectionPresenterTest.setLike(for: true)
        XCTAssertEqual(self.articlesViewDataMock[1], articleSelectionViewMock.nextArticle)
        articleSelectionPresenterTest.setLike(for: true)
        XCTAssertEqual(self.articlesViewDataMock[2], articleSelectionViewMock.nextArticle)
        articleSelectionPresenterTest.setLike(for: true)
        XCTAssertEqual(self.articlesViewDataMock[3], articleSelectionViewMock.nextArticle)
        articleSelectionPresenterTest.setLike(for: false)
        XCTAssertEqual(self.articlesViewDataMock[4], articleSelectionViewMock.nextArticle)
        articleSelectionPresenterTest.setLike(for: false)
    }
}
