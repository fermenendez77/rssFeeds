//
//  SignUpViewController.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import UIKit


protocol SignUpView : class {
    func showLoading()
    func hideLoading()
    func presentRSSFeedsScene()
}

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var newUserButton: UIButton!
    
    var presenter : SignUpPresenter?
    var onCompleted : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let completedAction = onCompleted {
            completedAction()
        }
    }
    
    private func setUIListeners() {
        usernameTextField.addTarget(self, action: #selector(self.userNameFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.passwordFieldDidChange(_:)), for: .editingChanged)
        newUserButton.isEnabled = false
    }
    
    @objc func userNameFieldDidChange(_ textField: UITextField) {
        newUserButton.isEnabled = textField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
    }
    
    @objc func passwordFieldDidChange(_ textField: UITextField) {
        newUserButton.isEnabled = textField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0
    }
    
    @IBAction func newUserAction(_ sender: Any) {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        presenter?.createAccount(with : username, password : password)
    }
    
    lazy var fetchingDataAlert : UIAlertController = {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        return alert
    }()
}

extension SignUpViewController : SignUpView {
    
    func showLoading() {
        present(fetchingDataAlert, animated: true, completion: nil)
    }
    
    func hideLoading() {
        fetchingDataAlert.dismiss(animated: true, completion: nil)
    }
    
    func presentRSSFeedsScene() {
        dismiss(animated: true, completion: nil)
    }
}
