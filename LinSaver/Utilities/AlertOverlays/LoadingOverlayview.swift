//
//  LoadingOverlayview.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 19/06/24.
//

import SwiftUI


struct LoadingOverlay<PresentingView: View>: View {
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    var loadingText: String

    var body: some View {
        ZStack {
            presentingView
                .blur(radius: isPresented ? 2 : 0)
                .animation(.easeInOut, value: isPresented)
                .allowsHitTesting(!isPresented) 
            
            if isPresented {
                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                    
                    Text(loadingText)
                        .foregroundColor(.white)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .frame(width: 200)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .transition(.scale)
                .animation(.spring(), value: isPresented)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(isPresented ? 0.25 : 0).edgesIgnoringSafeArea(.all))
    }
}

extension View {
    func loadingOverlay(isPresented: Binding<Bool>, loadingText: String) -> some View {
        LoadingOverlay(isPresented: isPresented, presentingView: self, loadingText: loadingText)
    }
}

struct LoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlay(isPresented: .constant(true), presentingView: Text("Hello, World!"), loadingText: "Loading, please wait...")
    }
}
