//
//  CustomAlertView.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 19/06/24.
//

import SwiftUI

struct RestorePurchaseAlertView: View {
    var alertText: String
    var onDismiss: () -> Void


    var body: some View {
        ZStack {
           
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Restore Purchases")
                    .foregroundColor(.black)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text(alertText)
                    .foregroundColor(.black)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    

                Button(action: {
                    onDismiss()
                }) {
                    Text("OK")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(.horizontal,20)
        }
    }
}

extension View {
    func restorePurchaseAlert(isPresented: Binding<Bool>, alertText: String, onDismiss: @escaping () -> Void) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                RestorePurchaseAlertView(alertText: alertText, onDismiss: onDismiss)
            }
        }
    }
}
