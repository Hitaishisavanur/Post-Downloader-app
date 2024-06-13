

import Foundation
import GoogleMobileAds

class InterstitialAdsManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    
    // Properties
   @Published var interstitialAdLoaded:Bool = false
    var interstitialAd:GADInterstitialAd?
    
    var onAdDismissed: (() -> Void)?
    
    override init() {
        super.init()
        loadInterstitialAd()
    }
    
    // Load InterstitialAd
    func loadInterstitialAd(){
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest()) { [weak self] add, error in
            guard let self = self else {return}
            if let error = error{
                print("🔴: \(error.localizedDescription)")
                self.interstitialAdLoaded = false
                return
            }
            print("🟢: Loading succeeded")
            self.interstitialAdLoaded = true
            self.interstitialAd = add
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    func getTopViewController(_ rootViewController: UIViewController? = nil) -> UIViewController? {
        let rootVC = rootViewController ?? UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
        if let presentedVC = rootVC?.presentedViewController {
            return getTopViewController(presentedVC)
        }
        if let navVC = rootVC as? UINavigationController {
            return getTopViewController(navVC.visibleViewController)
        }
        if let tabVC = rootVC as? UITabBarController {
            if let selectedVC = tabVC.selectedViewController {
                return getTopViewController(selectedVC)
            }
        }
        return rootVC
    }

    // Display InterstitialAd
    func displayInterstitialAd() {
        guard let topViewController = getTopViewController() else {
            print("🔴: Couldn't find top view controller")
            return
        }
        
        if let ad = interstitialAd {
            ad.present(fromRootViewController: topViewController)
            self.interstitialAdLoaded = false
        } else {
            print("🔵: Ad wasn't ready")
            self.interstitialAdLoaded = false
            self.loadInterstitialAd()
        }
    }
    
    // Display InterstitialAd
//    func displayInterstitialAd(){
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        guard let root = windowScene?.windows.first?.rootViewController else {
//            return
//        }
//        if let add = interstitialAd{
//            add.present(fromRootViewController: root)
//            self.interstitialAdLoaded = false
//        }else{
//            print("🔵: Ad wasn't ready")
//            self.interstitialAdLoaded = false
//            self.loadInterstitialAd()
//        }
//    }
//
    // Failure notification
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("🟡: Failed to display interstitial ad")
    
     
       
        self.loadInterstitialAd()
        onAdDismissed?()
    }
    
    // Indicate notification
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("🤩: Displayed an interstitial ad")
        
        self.interstitialAdLoaded = false
    }
    
    // Close notification
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        onAdDismissed?()
        
        self.loadInterstitialAd()
        print("😔: Interstitial ad closed")
        
            }
}

