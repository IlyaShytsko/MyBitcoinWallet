//
//  BlockstreamService.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 07/06/2024.
//

extension NetworkService {
    struct Blockstream {
        static func fetchUTXOs(for address: String) async throws -> [UT] {
            let transactions: [UT] = try await ApiClient.request(.fetchUTXOs(address: address))
            return transactions
        }
        
        static func broadcastTransaction(_ transaction: String) async throws {
            try await ApiClient.request(.broadcastTransaction(transaction: transaction))
        }
    }
}
