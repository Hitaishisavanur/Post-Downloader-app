import SwiftUI

struct ExceedsAlert<PresentingView: View>: View {
    
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    @State var showPro: Bool = false
    
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
                            
                            Text("Your free access limit is exceeded, kindly purchase premium to enjoy unlimited downloads, collections and bookmarks.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            HStack {
                                Button(action: {
                                    // Handle Buy Premium action
                                    showPro = true
                                    isPresented = false
                                }) {
                                    Text("Buy Pro")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    // Handle Watch Ads action
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
            .sheet(isPresented: $showPro) {
                PremiumAdPopup()
            }
    }
}

extension View {
    func exceedAlert(isPresented: Binding<Bool>) -> some View {
        ExceedsAlert(isPresented: isPresented, presentingView: self)
    }
}

#Preview {
    ExceedsAlert(isPresented: .constant(true), presentingView: Text("Hello World"))
}
