//
//  BlockstreamApiRouter.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 08/06/2024.
//

import Foundation
import Alamofire

enum BlockstreamApiRouter: URLRequestConvertible {
    
    // MARK: - Endpoints
    
    case fetchUTXOs(address: String)
    case broadcastTransaction(transaction: String)
    
    // MARK: - Endpoints configuration
    
    var config: RequestConfig {
        switch self {
            
        case .fetchUTXOs(let address):
            return RequestConfig(
                path: "address/\(address)/utxo",
                method: .get,
                encoding: URLEncoding.default
            )
        case .broadcastTransaction(let transaction):
            return RequestConfig(
                path: "tx",
                method: .post, 
                params: ["tx": transaction],
                encoding: JSONEncoding.default
            )
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let baseUrl = Config.blockstreamURL
        let request = try URLRequest(url: baseUrl.asURL().appendingPathComponent(config.path), method: config.method)
        return try config.encoding.encode(request, with: config.params)
    }
}
