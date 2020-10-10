//
//  LoginResponse.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//


import Foundation

struct LoginResponse: Codable {
    
    let accessToken: String
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case userID = "user_id"
    }
}
