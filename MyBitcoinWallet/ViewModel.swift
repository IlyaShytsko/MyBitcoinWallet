//
//  ViewModel.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 08/06/2024.
//

import Foundation
import BitcoinKit
import SwiftUI

@MainActor
final class ViewModel: ObservableObject {
    @Published var unspentTransaction: [UT] = []
    @Published var balanceInSatoshi: UInt64 = 0
    @Published var btcToUSDRate: UInt64?
    
    @Published var feePerByte: UInt64 = 10
    @Published var addressToSend = ""
    @Published var amountToSend: String = ""
    @Published var isLoading = true
    @Published var isSending = false
    @Published var showAlert = false
    @Published var alertMesage = ""

    var usdEquivalentAmount: String? {
        let balanceInBTC = Double(balanceInSatoshi) / 100_000_000
        let balansInUsd = balanceInBTC * Double(btcToUSDRate ?? 0)
        return String(format: "%.2f", balansInUsd)
    }
    
    var enableCreateButton: Bool {
        addressToSend.isNotEmpty && amountToSend.isNotEmpty && !isSending
    }
    
    var balanceInBCT: String { "\(Double(balanceInSatoshi) / 100_000_000) BTC" }
    
    func calculateBalance() {
        balanceInSatoshi = unspentTransaction.reduce(0) { $0 + $1.value }
    }
    
    func getLastTransaction(from utxos: [UT]) -> UT? {
        return utxos
            .filter { $0.status.confirmed }
            .sorted { ($0.status.block_time ?? 0) > ($1.status.block_time ?? 0) }
            .first
    }
    
    func createAndSignTransaction() throws -> String {

        // Validate and calculate amount to send in satoshis
        guard let amount = Double(amountToSend), amount > 0 else {
            throw TransactionError.invalidAmount
        }
        
        // Validate recipient address
        guard let toAddress = try? BitcoinAddress(legacy: addressToSend) else {
            throw TransactionError.invalidAddress
        }
        
        let amountToSend = UInt64(amount * 100_000_000)
        
        // Estimate transaction fee
        let estimatedSize: UInt64 = 250
        let fee = feePerByte * estimatedSize
        
        // Select UTXO
        guard let utxo = unspentTransaction.first(where: { $0.value >= amountToSend + fee }) else {
            throw TransactionError.insufficientFunds
        }

        // Prepare transaction inputs and outputs
        let outpoint = TransactionOutPoint(hash: Data(Data(hex: utxo.txid)!.reversed()), index: UInt32(utxo.vout))
        let change: UInt64 = balanceInSatoshi - amountToSend - fee
        let privateKey = try PrivateKey(wif: Config.privateKey)
        let changeAddress = privateKey.publicKey().toBitcoinAddress()
        
        let lockScript = Script(address: changeAddress)!.data
        let output = TransactionOutput(value: utxo.value, lockingScript: lockScript)
        let unspentTransaction = UnspentTransaction(output: output, outpoint: outpoint)
        
        let plan = TransactionPlan(unspentTransactions: [unspentTransaction], amount: amountToSend, fee: fee, change: change)
        let transaction = TransactionBuilder.build(from: plan, toAddress: toAddress, changeAddress: changeAddress)
        
        // Sign the transaction
        let sighashHelper = BTCSignatureHashHelper(hashType: .ALL)
        let sighash = sighashHelper.createSignatureHash(of: transaction, for: unspentTransaction.output, inputIndex: 0)
        let _ = privateKey.sign(sighash)
        
        let signer = TransactionSigner(unspentTransactions: plan.unspentTransactions, transaction: transaction, sighashHelper: sighashHelper)
        let signedTransaction = try signer.sign(with: [privateKey])

        return signedTransaction.serialized().hex
    }

    enum TransactionError: Error {
        case invalidAddress
        case invalidAmount
        case insufficientFunds
    }
    
    func sendTransaction() async throws {
        let tx = try createAndSignTransaction()
        try await NetworkService.Blockstream.broadcastTransaction(tx)
        isSending = false
    }
}
