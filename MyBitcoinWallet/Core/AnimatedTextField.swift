//
//  AnimatedTextField.swift
//  MyBitcoinWallet
//
//  Created by Ilya Shytsko on 10/06/2024.
//

import SwiftUI

struct AnimatedTextField<Trailing: View>: View {
    let placeholder: String
    
    @Binding
    var text: String
    
    init(
        placeholder: String,
        text: Binding<String>,
        isErroneous: Binding<Bool>,
        showCheckMark: Bool = false,
        trailing: Trailing = EmptyView()
    ) {
        self.placeholder = placeholder
        self._text = text
    }
    
    init(
        placeholder: String,
        text: Binding<String>,
        showCheckMark: Bool = false,
        trailing: Trailing = EmptyView()
    ) {
        self.placeholder = placeholder
        self._text = text
    }
    
    @FocusState
    private var focused: Bool
    
    @Environment(\.isEnabled)
    private var isEnabled
    
    private var isActive: Bool {
        focused || text.isNotEmpty
    }
    
    private var placeholderOffset: CGSize {
        .init(width: isActive ? 8 : 12, height: isActive ? -22 : 0)
    }
    
    private var backgroundColor: Color {
        isEnabled ? .clear : Color.gray
    }
    
    private var strokeColor: Color {
        return focused ? .black : Color.gray
    }
    
    private var placehoderColor: Color {
        return isActive ? .black : .gray
    }
    
    private var placeholderBackground: Color {
        isActive ? Color.white :  Color.white.opacity(0)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(backgroundColor)
            
            HStack {
                TextField("", text: $text)
                    .autocorrectionDisabled(true)
                    .disabled(!isEnabled)
                    .font(.system(size: 15))
                    .focused($focused)
            }
            .frame(height: 44)
            .padding(.horizontal, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .strokeBorder(strokeColor, lineWidth: 1)
            )
            
            Text(placeholder)
                .padding(.horizontal, isActive ? 4 : 0)
                .font(.system(size: isActive ? 12 : 15))
                .background(placeholderBackground)
                .foregroundColor(placehoderColor)
                .offset(placeholderOffset)
                .animation(.easeOut(duration: 0.1), value: focused)
                .onTapGesture {
                    focused = true
                }
        }
    }
}

#Preview {
    struct Preview: View {
        @State
        var text: String = "test"
        
        var body: some View {
            AnimatedTextField(
                placeholder: "test",
                text: $text,
                showCheckMark: true
            )
            .padding()
        }
        
        @ViewBuilder
        func trailing() -> some View {
            if text.isNotEmpty {
                Button {
                    text = ""
                } label: {
                    Text("Apply")
                }
            }
        }
    }
    
    return Preview()
}
