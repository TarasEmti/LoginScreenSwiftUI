//
//  ErrorProtocol.swift
//  loginApp
//
//  Created by Тарас Минин on 23/05/2021.
//

protocol UserReadableError: Error {
    func errorText() -> String
}

enum Result<T: UserReadableError> {
    case success
    case error(_ error: T)
}
