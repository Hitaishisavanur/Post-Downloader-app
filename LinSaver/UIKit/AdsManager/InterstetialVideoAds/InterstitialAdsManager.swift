

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
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-8357680786475707/8157918279", request: GADRequest()) { [weak self] add, error in
            guard let self = self else {return}
            if let error = error{
                
                self.interstitialAdLoaded = false
                return
            }
           
            self.interstitialAdLoaded = true
            self.interstitialAd = add
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    func getTopViewController(_ rootViewController: UIViewController? = nil) -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
                let rootVC = rootViewController ?? windowScene?.windows.first { $0.isKeyWindow }?.rootViewController
        //let rootVC = rootViewController ?? UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
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
            
            return
        }
        
        if let ad = interstitialAd {
            ad.present(fromRootViewController: topViewController)
            self.interstitialAdLoaded = false
        } else {
            
            self.interstitialAdLoaded = false
            self.loadInterstitialAd()
        }
    }

    // Failure notification
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
       
    
     
       
        self.loadInterstitialAd()
        onAdDismissed?()
    }
    
    // Indicate notification
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
        self.interstitialAdLoaded = false
    }
    
    // Close notification
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        onAdDismissed?()
        
        self.loadInterstitialAd()
       
        
            }
}

