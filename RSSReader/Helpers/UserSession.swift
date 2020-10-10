//
//  UserSession.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import Foundation

class UserSession {
    
    static func saveUser(user : LoginResponse) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userLogged")
        }
    }
    
    static func getUserToken() -> String? {
        if let user = UserDefaults.standard.data(forKey: "userLogged") {
            if let decoded = try? JSONDecoder().decode(LoginResponse.self, from: user) {
                return decoded.accessToken
            }
        }
        return nil
    }
    
    static func endSession() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}
