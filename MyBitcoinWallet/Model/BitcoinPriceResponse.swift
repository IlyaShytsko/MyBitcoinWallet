//
//  BitcoinPriceResponse.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 08/06/2024.
//

struct BitcoinPriceResponse: Codable {
    let bitcoin: Bitcoin
    
    struct Bitcoin: Codable {
        let usd: Double
    }
}
