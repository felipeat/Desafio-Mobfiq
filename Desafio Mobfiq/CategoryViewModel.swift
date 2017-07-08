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
    var title: String
    
    init(with category: Category) {
        self.category = category
        self.title = category.name!
    }
}
