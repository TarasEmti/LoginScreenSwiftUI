//
//  PasswordValidator.swift
//  loginApp
//
//  Created by Тарас Минин on 23/05/2021.
//

struct PasswordValidator {

    private let minLength: Int = 8

    private let forbiddenPasswords = [
        "admin", // Required by task, but this password is shorter than 8 characters 🤷‍♂️
        "password",
        "12345678",
        "00000000",
        "qweasdqweasd",
        "qwertyuiop",
    ]

    func isValid(_ password: String) -> Result<PasswordValidatorError> {
        if password.count < minLength {
            return .error(.shortPassword(length: minLength))
        }
        if forbiddenPasswords.contains(password) {
            return .error(.weakPassword)
        }

        return .success
    }

    func isMatching(
        _ original: String,
        _ repeated: String
    ) -> Result<PasswordValidatorError> {
        if original != repeated { return .error(.mismatch)}

        return .success
    }
}

extension PasswordValidator {

    enum PasswordValidatorError: UserReadableError {
        case shortPassword(length: Int)
        case weakPassword
        case mismatch

        func errorText() -> String {
            switch self {
            case .shortPassword(let length):
                return "Password should be more than \(length) characters"
            case .weakPassword:
                return "This password is insecure"
            case .mismatch:
                return "Passwords do not match"
            }
        }
    }
}

