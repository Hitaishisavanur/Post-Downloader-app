import SwiftUI

struct CustomAlert<PresentingView: View>: View {
    @Binding var isPresented: Bool
    @State var text: String
    let presentingView: PresentingView
    @State var showPro: Bool = false
    var onSelection: (Bool) -> Void

    var body: some View {
        presentingView
            .overlay(
                ZStack {
                    if isPresented {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20) {
                            Text("Unlock Pro Features")
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                            
                            Text("Would you like to buy premium or watch ads to unlock the \(text) features?")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            HStack {
                                Button(action: {
                                    onSelection(false)
                                    showPro = true
                                    isPresented = false
                                }) {
                                    Text("Buy Pro")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    onSelection(true)
                                    isPresented = false
                                }) {
                                    Text("Watch Ads")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            
                            Button(action: {
                                onSelection(false)
                                isPresented = false
                            }) {
                                Text("Cancel")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .frame(width: 300)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .transition(.scale)
                        .animation(.spring(), value: isPresented)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            )
            .onAppear{
                
            }
            .sheet(isPresented: $showPro) {
                PremiumAdPopup()
            }
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>,text: String, onSelection: @escaping (Bool) -> Void) -> some View {
        CustomAlert(isPresented: isPresented, text: text, presentingView: self, onSelection: onSelection)
    }
}

#Preview {
    CustomAlert(isPresented: .constant(true), text: "save or share", presentingView: DownloadCardView(viewModel: DownloadViewModel()), onSelection: { wt in })
}
