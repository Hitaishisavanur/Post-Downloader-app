

import SwiftUI
import RevenueCat

struct BottomTabView: View {
    @State private var showPremiumAd: Bool = true
    @EnvironmentObject var interstetialAdsManager: InterstitialAdsManager
    private let userViewModel = UserViewModel.shared
    @State var isPresentedAd: Bool = false
   // @State var customerInfo: CustomerInfo?
    
    init(){
      
        }
    
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
                            
                        }.sheet(isPresented: $showPremiumAd){
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
}

#Preview {
    BottomTabView()
}

