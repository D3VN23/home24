//
//  SelectionService.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/1/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import Foundation

class ArticleSelectionService {
    
    func getArticles(for articlesIds: [String], callBack: @escaping ([Article]?, Error?) -> Void) {
        var articles = [Article]()
        let dispatchGroup = DispatchGroup()
        for id in articlesIds {
            dispatchGroup.enter()
            self.getArticle(for: id) { article, error in
                dispatchGroup.leave()
                if let article = article {
                    articles.append(article)
                } else {
                    print("Error: \(error!)")
                    callBack(nil, error)
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            callBack(articles, nil)
        }
    }
    
    fileprivate func getArticle(for id: String, callBack: @escaping (Article?, Error?) -> Void) {
        NetworkManager.shared.getArticle(for: id) { article, error in
            if let article = article {
                callBack(article, nil)
            } else {
                callBack(nil, error)
            }
        }
    }
}
