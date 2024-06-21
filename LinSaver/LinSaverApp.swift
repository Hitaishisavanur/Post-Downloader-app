
import SwiftUI
import GoogleMobileAds
import RevenueCat

@main
struct LinSaverApp: App {
    let dataController = DataController.shared
    
    @StateObject var InterstetialAdsManager = InterstitialAdsManager()
    @StateObject var userViewModel = UserViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
  
    
    var body: some Scene {
        WindowGroup {
            BottomTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(InterstetialAdsManager)
                .environmentObject(userViewModel)
                .task {
                                   do {
                                      
                                       // Fetch the available offerings
                                       UserViewModel.shared.offerings = try await Purchases.shared.offerings()
                                   } catch {
                                       print("Error fetching offerings: \(error)")
                                   }
                               }
                .onAppear{
                    InterstetialAdsManager.loadInterstitialAd()
                                 
                }
             
        }
        
        
    }
    init(){
        Purchases.logLevel = .debug
           Purchases.configure(withAPIKey: "appl_KYZchksyZjhiNulOeNNgcpTCSPE")
        
        Purchases.shared.delegate = PurchasesDelegateHandler.shared
        _ = UserViewModel.shared// Initialize the user view model
         
                    
            
        
    }
}
class AppDelegate:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GADMobileAds.sharedInstance().start()
    
        return true
    }
    

}

