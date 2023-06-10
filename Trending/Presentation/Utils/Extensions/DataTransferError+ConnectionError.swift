//
//  DataTransferError+ConnectionError.swift
//  Trend
//
//  Created by Amr Saied on 29.10.19.
//

import Foundation

extension DataTransferError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
