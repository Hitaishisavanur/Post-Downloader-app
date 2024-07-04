//
//  RewardedAdManager.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 08/06/24.
//

import GoogleMobileAds
import SwiftUI

class RewardedAdManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    private var rewardedAd: GADRewardedAd?
    @Published var adLoaded = false
    @Published var userDidEarnReward = false

    override init() {
        super.init()
        loadAd()
    }

    func loadAd() {
        let adUnitID = "ca-app-pub-8357680786475707/2493897163" 
        GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] (ad, error) in
            if let error = error {
                
                self?.adLoaded = false
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.adLoaded = true
           
        }
    }

    func showAd(from rootViewController: UIViewController) {
        guard let ad = rewardedAd else {
          
            return
        }
        ad.present(fromRootViewController: rootViewController) { [weak self] in
            // User earned the reward
            let reward = ad.adReward
           
            self?.userDidEarnReward = true
        }
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
       
        loadAd()
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
        
        loadAd()
    }
}

