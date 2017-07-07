//
//  SearchResultViewModel.swift
//  Desafio Mobfiq
//
//  Created by Pro on 07/07/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

class SearchResultViewModel {
    
    let searchResult: SearchResult
    
    var total = 0
    
    init(with searchResult: SearchResult) {
        self.searchResult = searchResult
        self.total = searchResult.total!
    }
}
