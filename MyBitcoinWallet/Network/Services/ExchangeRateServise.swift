//
//  ExchangeRateServise.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 08/06/2024.
//

extension NetworkService {
    struct ExchangeRate {
        static func fetchBTCtoUSD() async throws -> UInt64  {
            let rate: BitcoinPriceResponse = try await ApiClient.request(.btcToUsd)
            return UInt64(rate.bitcoin.usd)
        }
    }
}
