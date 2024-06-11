//
//  ContentView.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 05/06/2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject
    private var viewModel: ViewModel
    
    @Environment(\.scenePhase)
    private var scenePhase
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .transition(.opacity)
                } else {
                    Home()
                        .navigationBarTitle("Bitcoin wallet", displayMode: .large)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: viewModel.isLoading)
        }
        .offlineAlert()
        .onChange(of: scenePhase) { oldScenePhase, newScenePhase in
            switch newScenePhase {
            case .active:
                initialAppTasks()
            case .inactive, .background:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func initialAppTasks() {
        Task {
            do {
                viewModel.btcToUSDRate = try await NetworkService.ExchangeRate.fetchBTCtoUSD()
                viewModel.unspentTransaction = try await NetworkService.Blockstream.fetchUTXOs(for: Config.walletAdress)
                viewModel.calculateBalance()
                viewModel.isLoading = false
            }
            catch {
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
