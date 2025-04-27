//
//  ActivePinSetupView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 23/04/25.
//

import SwiftUI

struct ActivePinSetupView: View {
    
    @Binding var isPinEnable: Bool
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ActivePinViewModel = ActivePinViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isPinEnable = viewModel.isPinEnable()
                    dismiss()
                } label: {
                    Text("Close")
                }
            }
            .padding(.trailing)
            Text("Set up PIN")
                .modifier(FeaturedTitleStyle(fontSize: 20.0))
                .padding()
            Text("Please digit 5 numbers to setup your pin.")
            TextField("", text: $viewModel.pin)
                .textFieldStyle(.roundedBorder)
                .padding(.top)
            Button {
                if viewModel.validatePin() {
                    viewModel.savePin()
                    viewModel.showAlert = false
                    dismiss()
                } else {
                    viewModel.showAlert = true
                }
            } label: {
                Text("Done")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 80)
            Spacer()
        }
        .padding()
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    ActivePinSetupView(isPinEnable: .constant(false))
}
