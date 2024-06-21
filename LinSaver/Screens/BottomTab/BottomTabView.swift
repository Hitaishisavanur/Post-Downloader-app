

import SwiftUI
import RevenueCat

struct BottomTabView: View {
    @State private var showPremiumAd: Bool = false
    @EnvironmentObject var interstetialAdsManager: InterstitialAdsManager
    private let userViewModel = UserViewModel.shared
    @State var isPresentedAd: Bool = false
   // @State var customerInfo: CustomerInfo?
    
   
    
    var body: some View {
        ZStack {
           
            TabView{
                
                if(userViewModel.subscriptionActive){
                    
                    
                    HomeScreenView(viewModel: HomeScreenViewModel())
                        .tabItem { Label("Home", systemImage: "house")
                            
                        }
                }else{
              
                    HomeScreenView(viewModel: HomeScreenViewModel())
                        .tabItem { Label("Home", systemImage: "house")
                            
                        }
                        
                        .onFirstAppear {
                            checkSubscriptionStatus()
                        }
                        .sheet(isPresented: $showPremiumAd){
                            PremiumAdPopup()
                                
                                
                        }
                        
                }
                
                
                CollectionsView(viewModel: CollectionsViewModel())
                    .tabItem { Label("Collections", systemImage: "rectangle.stack")
                    }
                
                BookmarkView()
                    .tabItem { Label("Bookmarks", systemImage: "bookmark")
                        
                    }
                
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape")
                    }
            }
        }
        
            
    }
    
    
    private func checkSubscriptionStatus() {
            // Fetch the customer info to update the subscription status
            userViewModel.refreshCustomerInfo()
            
            // Set the showPremiumAd state based on the subscription status
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showPremiumAd = !userViewModel.subscriptionActive
            }
        }
}

#Preview {
    BottomTabView()
}

