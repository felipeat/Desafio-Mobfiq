//
//  CategoryViewModel.swift
//  Desafio Mobfiq
//
//  Created by Pro on 07/07/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

class CategoryViewModel {
    
    let category: Category
    private(set) var attributedTitle: NSAttributedString
    var title : String
    var highlight: Bool = false
    
    init(with category: Category) {
        self.category = category
        self.highlight = category.highlight
        self.title = category.name!
        self.attributedTitle = NSAttributedString(string:category.name!)
    }
}
