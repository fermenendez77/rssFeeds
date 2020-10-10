//
//  RSSArticlesResponse.swift
//  RSSReader
//
//  Created by Fernando Menendez on 10/10/2020.
//

import Foundation

import Foundation

// MARK: - RSSArticlesResponse
struct RSSArticlesResponse: Codable {
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let id: Int
    let title: String
    let url: String
    let summary: String
    let date: String
    let loaded: String
}
