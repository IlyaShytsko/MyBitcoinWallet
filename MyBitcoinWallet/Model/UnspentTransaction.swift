//
//  UnspentTransaction.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 08/06/2024.
//

import Foundation
import BitcoinKit

struct UT: Decodable {
    let txid: String
    let vout: Int
    let status: TransactionStatus
    let value: UInt64

    struct TransactionStatus: Decodable {
        let confirmed: Bool
        let block_height: Int?
        let block_hash: String?
        let block_time: Int?
    }
}
