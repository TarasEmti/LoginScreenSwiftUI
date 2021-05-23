//
//  LoginViewModel.swift
//  loginApp
//
//  Created by Тарас Минин on 23/05/2021.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {

    @Published var accountName = ""
    @Published var password = ""
    @Published var passwordRepeat = ""

    @Published var accountError = ""
    @Published var passwordError = ""
    @Published var passwordMatchError = ""
    
    @Published var isValid = false

    private let network: Network
    private let passValidator = PasswordValidator()

    private var cancellableSet: Set<AnyCancellable> = []

    init(network: Network = MockNetwork()) {
        self.network = network

        isAccountAvailable
            .receive(on: RunLoop.main)
            .map { result in
                switch result {
                case .success:
                    return ""
                case .error(let error):
                    return error.errorText()
                }
            }.assign(to: \.accountError, on: self)
            .store(in: &cancellableSet)

        isPasswordValid
            .receive(on: RunLoop.main)
            .map { result in
                switch result {
                case .success:
                    return ""
                case .error(let error):
                    return error.errorText()
                }
            }.assign(to: \.passwordError, on: self)
            .store(in: &cancellableSet)

        isPasswordMatch
            .receive(on: RunLoop.main)
            .map { result in
                switch result {
                case .success:
                    return ""
                case .error(let error):
                    return error.errorText()
                }
            }.assign(to: \.passwordMatchError, on: self)
            .store(in: &cancellableSet)

        isFormValid
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }

    func reset() {
        accountName = ""
        password = ""
        passwordRepeat = ""
    }

    private var isAccountAvailable: AnyPublisher<Result<NetworkError>, Never> {
        $accountName
            .filter({ !$0.isEmpty })
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap({ self.checkAccount($0) })
            .eraseToAnyPublisher()
    }

    private func checkAccount(
        _ accountName: String
    ) -> AnyPublisher<Result<NetworkError>, Never> {

        return Deferred {
            Future { promise in
                self.network.isAccountAvailable(accountName) { result in
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }

    private var isPasswordValid: AnyPublisher<Result<PasswordValidator.PasswordValidatorError>, Never> {
        $password
            .filter({ !$0.isEmpty })
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { pass in
                self.passValidator.isValid(pass)
            }
            .eraseToAnyPublisher()
    }

    private var isPasswordMatch: AnyPublisher<Result<PasswordValidator.PasswordValidatorError>, Never> {
        $passwordRepeat
            .filter({ !$0.isEmpty })
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .combineLatest($password)
            .filter({ !$0.1.isEmpty})
            .map { passRepeat, pass  in
                self.passValidator.isMatching(pass, passRepeat)
            }
            .eraseToAnyPublisher()
    }

    private var isFormValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isAccountAvailable, isPasswordValid, isPasswordMatch).map { a, b, c in
            if case .error = a { return false }
            if case .error = b { return false }
            if case .error = c { return false }
            return true
        }
        .eraseToAnyPublisher()
    }
}
