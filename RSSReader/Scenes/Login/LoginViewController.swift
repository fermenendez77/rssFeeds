//
//  ViewController.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import UIKit

protocol LoginView : class {
    
    func showLoading()
    func hideLoading()
    func presentRSSFeedsScene()
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var loginButton : UIButton!
    
    private var presenter : LoginPresenter?
    
    lazy var fetchingDataAlert : UIAlertController = {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        return alert
    }()
    
    /*
    lazy var errorAlert : UIAlertController = {
        
        let alert = UIAlertController(title: "Error", message: "There is an error Fetching the data", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { [weak self] alert in
            self?.presenter?.viewDidLoad()
        }
        alert.addAction(action)
        return alert
    }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIListeners()
        presenter = LoginPresenterImp(view: self)
    }
    
    private func setUIListeners() {
        userTextField.addTarget(self, action: #selector(self.userNameFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.passwordFieldDidChange(_:)), for: .editingChanged)
        loginButton.isEnabled = false
    }
    
    @objc func userNameFieldDidChange(_ textField: UITextField) {
        loginButton.isEnabled = textField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
    }
    
    @objc func passwordFieldDidChange(_ textField: UITextField) {
        loginButton.isEnabled = textField.text?.count ?? 0 > 0 && userTextField.text?.count ?? 0 > 0
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        guard let username = userTextField.text, let password = passwordTextField.text else {
            return
        }
        presenter?.loginUser(username: username, password: password)
    }
}

extension LoginViewController : LoginView {
    
    func presentRSSFeedsScene() {
        let rssFeedsVC = RSSFeedsViewController()
        let feedsPresenter = RSSFeedsPresenterImp(view: rssFeedsVC)
        rssFeedsVC.presenter = feedsPresenter
        self.navigationController?.pushViewController(rssFeedsVC, animated: true)
    }
    
    
    func showLoading() {
        present(fetchingDataAlert, animated: true, completion: nil)
    }
    
    func hideLoading() {
        fetchingDataAlert.dismiss(animated: true, completion: nil)
    }
    
    
}
