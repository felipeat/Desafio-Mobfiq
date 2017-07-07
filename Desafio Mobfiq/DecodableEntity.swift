//
//  DecodableEntity.swift
//  Desafio Mobfiq
//
//  Created by Pro on 07/07/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

protocol DecodableEntity {
    init(withDictionary dict: [String:Any])
}
