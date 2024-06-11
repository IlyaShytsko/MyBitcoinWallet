//
//  ApiClient.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 08/06/2024.
//

import Foundation
import Alamofire
import BitcoinKit

final class ApiClient {
    static func request<Model: Decodable>(_ route: ExchangeApiRouter) async throws -> Model {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let response = await AF.request(route)
            .validate()
            .serializingDecodable(Model.self, decoder: decoder)
            .response
    
        switch response.result {
        case .success(let model):
            return model
        case .failure(let error):
            throw response.serviceError(error)
        }
    }
    
    static func request<Model: Decodable>(_ route: BlockstreamApiRouter) async throws -> Model {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let response = await AF.request(route)
            .validate()
            .serializingDecodable(Model.self, decoder: decoder)
            .response
    
        switch response.result {
        case .success(let model):
            return model
        case .failure(let error):
            throw response.serviceError(error)
        }
    }
    
    static func request(_ route: BlockstreamApiRouter) async throws {
        let response = await AF.request(route).validate().serializingData().response
        
        switch response.result {
        case .failure(let error):
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                print("Error response data: \(responseString)")
            }
            print("Error: \(error)")
            throw error
        case .success(let data):
            if let responseString = String(data: data, encoding: .utf8) {
                print("Success response data: \(responseString)")
            }
        }
    }
}
