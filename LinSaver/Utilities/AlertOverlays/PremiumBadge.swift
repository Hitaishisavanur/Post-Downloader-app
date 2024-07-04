import SwiftUI

struct PremiumBadge<PresentingView: View>: View {
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    var remainingText: String
    @State var showingPremiumAd = false

    var body: some View {
        ZStack {
            presentingView

            if isPresented {
                GeometryReader { geometry in
                    VStack {
                        Spacer()

                        VStack(spacing: 20) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(remainingText)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    Text("Become a Premium member and enjoy unlimited downloads, collections, bookmarks and save to Photos")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                VStack {
                                    Button(action: {
                                        // Handle the button action here
                                        showingPremiumAd = true
                                    }) {
                                        Text("Buy Premium")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    .buttonStyle(BorderedProminentButtonStyle())
                                }
                            }
                            .padding(3)
                        }
                        .padding(3)
                        .background(Color.black.opacity(0.95))
                       
                        .frame(maxWidth: .infinity)
                       
                        .padding(.bottom, 25) 
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(isPresented ? 0.25 : 0).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingPremiumAd ){
            PremiumAdPopup()
        }
    }
}

extension View {
    func premiumBadge(isPresented: Binding<Bool>, remainingText: String) -> some View {
        PremiumBadge(isPresented: isPresented, presentingView: self, remainingText: remainingText)
    }
}

struct PremiumBadge_Previews: PreviewProvider {
    static var previews: some View {
        PremiumBadge(isPresented: .constant(true), presentingView: Text("Hello, World!"), remainingText: "Loading, please wait...")
    }
}
