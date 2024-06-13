
import SwiftUI
import GoogleMobileAds
import RevenueCat

@main
struct LinSaverApp: App {
    let dataController = DataController.shared
    @StateObject var viewModel = SettingsViewModel()
    @StateObject var InterstetialAdsManager = InterstitialAdsManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            BottomTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(viewModel)
                .environmentObject(InterstetialAdsManager)
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
        
    }
}
class AppDelegate:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GADMobileAds.sharedInstance().start()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        print("Notification permissions granted.")
                    } else if let error = error {
                        print("Notification permission error: \(error)")
                    }
                }
        return true
    }
    

}

