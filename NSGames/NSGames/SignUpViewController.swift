//
//  SignUpViewController.swift
//  NSGames
//
//  Created by Nikita Sosyuk on 05.03.2021.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: - MVVM propertiesb
    var viewModel: SignUpViewModel?

    // MARK: - UI
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = #imageLiteral(resourceName: "NSGames-icon")
        return iconImageView
    }()

    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание аккаунта"
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()

    let loginTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = "Логин"
        return textField
    }()

    let emailTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        return textField
    }()

    let passwordTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        return textField
    }()

    let passwordAgainTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = "Пароль еще раз"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()

    let haveAccount: GrayLabel = {
        let label = GrayLabel()
        label.text = "Уже есть аккаунт?"
        label.font = UIFont.systemFont(ofSize: 15)
        label.tintColor = .grayLabel
        return label
    }()

    var signInButton: BlueTextButton = {
        let button = BlueTextButton()
        button.setTitle("Войдите", for: .normal)
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        return button
    }()

    let signUpButton: BlueButton = {
        let button = BlueButton()
        button.setTitle("Создать аккаунт", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        return button
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    let userDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()

    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас нет аккаунта?"
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        label.numberOfLines = 2
        label.textColor = .red
        return label
    }()

    let scrollView = UIScrollView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        constraints()
        title = "Создание аккаунта"
        view.backgroundColor = .white
        loginTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            emailTextField.becomeFirstResponder()

        case emailTextField:
            passwordTextField.becomeFirstResponder()

        case passwordTextField:
            passwordAgainTextField.becomeFirstResponder()

        default:
            textField.resignFirstResponder()
        }
        return false
    }

    // MARK: - obcj func
    @objc private func signInButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func signUpButtonAction() {
        viewModel?.signUp(login: loginTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "", passwordAgain: passwordAgainTextField.text ?? "")
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + keyboardSize.height)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize = scrollView.frame.size
    }

    // MARK: - Helpers

    private func constraints() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(scrollView.snp.width).multipliedBy(0.3)
        }

        scrollView.addSubview(signUpLabel)
        signUpLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
        }

        userDataStackView.addArrangedSubview(loginTextField)
        userDataStackView.addArrangedSubview(emailTextField)
        userDataStackView.addArrangedSubview(passwordTextField)
        userDataStackView.addArrangedSubview(passwordAgainTextField)
        scrollView.addSubview(userDataStackView)
        userDataStackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(signUpLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }

        scrollView.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(userDataStackView.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }

        stackView.addArrangedSubview(haveAccount)
        stackView.addArrangedSubview(signInButton)
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalTo(signUpButton.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }

    private func bindData() {
        viewModel?.signUpError.bind { [weak self] text in
            guard let self = self else { return }
            self.errorLabel.text = text
            self.userDataStackView.addArrangedSubview(self.errorLabel)
        }
    }
}
