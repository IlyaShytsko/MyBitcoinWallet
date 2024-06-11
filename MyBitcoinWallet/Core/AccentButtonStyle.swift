//
//  AccentButtonStyle.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 07/06/2024.
//

import SwiftUI

struct AccentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled)
    var isEnabled
    
    private let pressedColor = Color.blue
    private let disabledColor = Color.gray
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isEnabled ? (configuration.isPressed ? pressedColor : Color.black) : disabledColor)
            }
    }
}
