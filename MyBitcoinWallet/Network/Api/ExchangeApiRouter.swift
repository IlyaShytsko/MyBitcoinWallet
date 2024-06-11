//
//  ExchangeApiRouter.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 08/06/2024.
//

import Alamofire
import Foundation

struct RequestConfig {
    let path: String
    let method: HTTPMethod
    var params: Parameters?
    let encoding: ParameterEncoding
}

enum ExchangeApiRouter: URLRequestConvertible {
    
    // MARK: - Endpoints
    
    case btcToUsd
    
    // MARK: - Endpoints configuration
    
    var config: RequestConfig {
        switch self {
            
        case .btcToUsd:
            return RequestConfig(
                path: "simple/price",
                method: .get,
                params: ["ids": "bitcoin", "vs_currencies": "usd"],
                encoding: URLEncoding.default
            )
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let baseUrl = Config.exchangeURL
        let request = try URLRequest(url: baseUrl.asURL().appendingPathComponent(config.path), method: config.method)
        return try config.encoding.encode(request, with: config.params)
    }
}
