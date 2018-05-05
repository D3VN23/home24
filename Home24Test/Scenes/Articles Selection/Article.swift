//
//  Article.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/1/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import UIKit

class Article: Decodable {
    var sku: String
    var title: String
    var media: [Image]
}

class Image: Decodable {
    var uri: String
}
