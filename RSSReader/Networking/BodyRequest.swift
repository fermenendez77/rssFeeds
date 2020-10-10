//
//  BodyRequest.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import Foundation

struct BodyRequest<T : Codable> {
    
    private let body : T
    
    init(body: T) {
        self.body = body
    }
}
