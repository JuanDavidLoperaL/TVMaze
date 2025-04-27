//
//  PreLoginView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import SwiftUI

struct PreLoginView: View {
    
    @ObservedObject var viewModel: PreLoginViewModel
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .preparating:
                Text("Building App waiting please...")
            case .biometric:
                Text("Authentication Required")
                    .font(.title)
                    .padding()
                Text("Tap in button below to start Authentication procces.")
                padding([.horizontal, .bottom])
                Spacer()
            case .pin:
                Text("PIN Required")
                    .font(.title)
                    .padding()
                Text("Digit your PIN 5 numbers only.")
                TextField("", text: $viewModel.pin)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top)
            }
            Button(viewModel.buttonTitle) {
                viewModel.validate {
                    isLoggedIn = viewModel.isValidationSuccessful
                }
            }
        }
        .padding()
        .alert("Authentication Failed", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            viewModel.preparePreLogin()
        }
    }
}

#Preview {
    PreLoginView(viewModel: PreLoginViewModel(isPinEnable: false, isBiometricEnable: true), isLoggedIn: .constant(false))
}
