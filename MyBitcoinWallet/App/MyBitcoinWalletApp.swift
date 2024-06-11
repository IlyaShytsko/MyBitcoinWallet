//
//  MyBitcoinWalletApp.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 05/06/2024.
//

import SwiftUI

@main
struct MyBitcoinWalletApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var delegate
    
    @StateObject
    private var viewModel = ViewModel()
    
    @ObservedObject 
    private var monitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(monitor)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
