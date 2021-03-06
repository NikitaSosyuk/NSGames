//
//  SignInService.swift
//  NSGames
//
//  Created by Nikita Sosyuk on 08.03.2021.
//

import Foundation

protocol SignInService {
    func signIn(email: String, password: String, completion: @escaping (Result<(), SignInError>) -> Void)
}

class MockSignInService: SignInService {
    func signIn(email: String, password: String, completion: @escaping (Result<(), SignInError>) -> Void) {
        if email == "123" && password == "123" {
            return completion(.success(()))
        }
        if email == "1234" && password == "1234" {
            return completion(.failure(.wrongData))
        }
        return completion(.failure(.noConnection))
    }
}
