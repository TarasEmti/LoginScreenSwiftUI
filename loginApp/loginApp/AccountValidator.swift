//
//  AccountValidator.swift
//  loginApp
//
//  Created by Тарас Минин on 23/05/2021.
//

struct AccountValidator {

    enum AccountValidatorError: UserReadableError {
        case shortName
        case unavailable

        func errorText() -> String {
            switch self {
            case .shortName:
                return "Account name is too short"
            case .unavailable:
                return "Account name is unavailable"
            }
        }
    }

    private let unavailableNames = [
        "admin",
        "admin1",
        "owner",
        "swiftui"
    ]

    private let minLength: Int = 5

    func isAvailable(_ accountName: String) -> Result<AccountValidatorError> {
        if unavailableNames.contains(accountName.lowercased()) {
            return .error(.unavailable)
        }

        return .success
    }

    func isValid(_ accountName: String) -> Result<AccountValidatorError> {
        if accountName.count < minLength { return .error(.shortName) }

        return .success
    }
}
