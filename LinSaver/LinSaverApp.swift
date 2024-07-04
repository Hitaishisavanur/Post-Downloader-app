
import SwiftUI
import GoogleMobileAds
import RevenueCat
import FirebaseCore

@main
struct LinSaverApp: App {
    let dataController = DataController.shared
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    @StateObject var InterstetialAdsManager = InterstitialAdsManager()
    @StateObject var userViewModel = UserViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let crashlyticsManager = CrashlyticsManager.shared
    
  
    
    var body: some Scene {
        WindowGroup {
            if hasLaunchedBefore {
                
                BottomTabView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(InterstetialAdsManager)
                    .environmentObject(userViewModel)
                    .task {
                                       do {
                                          
                                           // Fetch the available offerings
                                           UserViewModel.shared.offerings = try await Purchases.shared.offerings()
                                           
                                       } catch {
                                           crashlyticsManager.addLog(message: error.localizedDescription)
                                       }
                                   }
                  
                 
            
            } else {
                // Is first launch
                // Load tutorial SwiftUI view here
                 // Set hasLaunchedBefore key to true
                BottomTabView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(InterstetialAdsManager)
                    .environmentObject(userViewModel)
                    .task {
                                       do {
                                          
                                           // Fetch the available offerings
                                           UserViewModel.shared.offerings = try await Purchases.shared.offerings()
                                       } catch {
                                       }
                                   }
                    .onAppear{
                        
                        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                    }
            }
            
//            BottomTabView()
//                .environment(\.managedObjectContext, dataController.container.viewContext)
//                .environmentObject(InterstetialAdsManager)
//                .environmentObject(userViewModel)
//                .task {
//                                   do {
//                                      
//                                       // Fetch the available offerings
//                                       UserViewModel.shared.offerings = try await Purchases.shared.offerings()
//                                   } catch {
//                                   }
//                               }
//                .onAppear{
//                    InterstetialAdsManager.loadInterstitialAd()
//                                 
//                }
//             
        }
        
        
    }
    init(){
        Purchases.logLevel = .debug
           Purchases.configure(withAPIKey: "appl_KYZchksyZjhiNulOeNNgcpTCSPE")
        
        Purchases.shared.delegate = PurchasesDelegateHandler.shared
        _ = UserViewModel.shared// Initialize the user view model
         
        InterstetialAdsManager.loadInterstitialAd()
            
        
    }
}
class AppDelegate:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GADMobileAds.sharedInstance().start()
        FirebaseApp.configure()
        
        
        return true
    }
    

}

