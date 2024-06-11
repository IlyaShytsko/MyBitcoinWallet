//
//  Home.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 07/06/2024.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject
    private var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Balance")
                .font(.title2)
                .fontWeight(.medium)
            
            Text(viewModel.balanceInBCT)
                .padding(.top, 8)
            
            Text("≈ \(viewModel.usdEquivalentAmount ?? "")$")
                .font(.caption)
            AnimatedTextField(placeholder: "Amount to send", text: $viewModel.amountToSend)
                .keyboardType(.decimalPad)
                .frame(height: 50)
                .padding(.top, 16)
            
            AnimatedTextField(placeholder: "Address to send", text: $viewModel.addressToSend)
                .frame(height: 50)
                .padding(.top, 8)
            
            Spacer()
            Button("Send") {
                sendAction()
            }
            .disabled(!viewModel.enableCreateButton)
            .buttonStyle(AccentButtonStyle())
            .padding(.top, 16)
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.alertMesage),
                dismissButton: .default(Text("OK")) {
                    viewModel.showAlert = false
                }
            )
        }
        
    }
    
    private func sendAction() {
        Task {
            do {
                viewModel.isSending = true
                try await viewModel.sendTransaction()
            }
            catch {
                viewModel.isSending = false
                viewModel.alertMesage = "\(error)"
                viewModel.showAlert = true
            }
        }
    }
}

//#Preview {
//    Home()
//}
