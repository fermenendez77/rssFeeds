//
//  LoginPresenter.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import Foundation

protocol LoginPresenter : class {
    
    init(view : LoginView)
    func loginUser(username : String, password : String)
}

class LoginPresenterImp : LoginPresenter {
    
    weak var view : LoginView?
    
    required init(view: LoginView) {
        self.view = view
    }
    
    func loginUser(username : String, password : String) {
        
        view?.showLoading()
        
        let userLogin = UserLogin(user: username, password: password)
        let restClient = RestClientService(urlBase: "167.99.162.146")
        restClient.dataRequest(endpoint: "/users/login",
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
        saveUser(user: response)
        view?.hideLoading()
        view?.presentRSSFeedsScene()
    }
    
    func saveUser(user : LoginResponse) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userLogged")
        }
    }
}
