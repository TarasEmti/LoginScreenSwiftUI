//
//  Network.swift
//  loginApp
//
//  Created by Тарас Минин on 23/05/2021.
//

protocol Network {
    func isAccountAvailable(
        _ accountName: String,
        completion: @escaping(Result<NetworkError>) -> Void
    )
}

struct NetworkError: UserReadableError {
    let apiError: UserReadableError

    func errorText() -> String { apiError.errorText() }
}

final class MockNetwork: Network {

    private let accountValidator = AccountValidator()

    func isAccountAvailable(
        _ accountName: String,
        completion: @escaping (Result<NetworkError>) -> Void
    ) {
        let valid = accountValidator.isValid(accountName)

        switch valid {
        case .error(let error):
            completion(.error(error.toNetworkError()))
            return

        case .success: break
        }

        let available = accountValidator.isAvailable(accountName)

        switch available {
        case .error(let error):
            completion(.error(error.toNetworkError()))
            return

        case .success: break
        }

        completion(.success)
    }
}

extension UserReadableError {
    func toNetworkError() -> NetworkError {
        NetworkError(apiError: self)
    }
}
