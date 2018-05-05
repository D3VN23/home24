//
//  ArticleCollectionViewCell.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/1/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleLikeLabel: UILabel!
    
    override func prepareForReuse() {
        self.articleLikeLabel.isHidden = true
    }
}
