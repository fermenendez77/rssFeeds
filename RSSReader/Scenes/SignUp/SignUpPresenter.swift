//
//  SignUpPresenter.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import Foundation

protocol SignUpPresenter : class {
    init(view : SignUpView)
    func createAccount(with username : String, password : String)
}

class SignUpPresenterImp : SignUpPresenter {
    
    weak var view : SignUpView?
    
    required init(view: SignUpView) {
        self.view = view
    }
    
    func createAccount(with username: String, password: String) {
        requestNewUser(username: username, password: password)
    }
    
    func requestNewUser(username : String, password : String) {
        view?.showLoading()
        
        let userLogin = UserLogin(user: username, password: password)
        let restClient = RestClientService(urlBase: "167.99.162.146")
        restClient.dataRequest(endpoint: "/users/register",
                               body: userLogin,
                               method: .POST,
                               returnType: LoginResponse.self,
                               completionHandler: { [weak self] response in
                                    self?.loginSuccessful(response: response)
                               },
                               errorHandler: { [weak self] error in
                                
                               })
    }
    
    func loginSuccessful(response : LoginResponse) {
        view?.hideLoading()
        saveUser(user : response)
        view?.presentRSSFeedsScene()
    }
    
    func saveUser(user : LoginResponse) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userLogged")
        }
    }
}


