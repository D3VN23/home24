//
//  ListReviewViewController.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/1/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import UIKit
import AlamofireImage

class ListReviewViewController: UIViewController {
    var articles: [ArticleViewData]!
}

//MARK: - Tableview Delegate + Data Source
extension ListReviewViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.articleList, for: indexPath) as! ArticleListTableViewCell
        cell.articleTitleLabel.text = self.articles[indexPath.row].title
        cell.articleImageView.af_setImage(withURL: self.articles[indexPath.row].image, imageTransition: .crossDissolve(0.3))
        self.articles[indexPath.row].liked ? (cell.articleLikeLabel.isHidden = false) : ()
        return cell
    }
}
