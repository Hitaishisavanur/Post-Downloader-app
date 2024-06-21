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
        let adUnitID = "ca-app-pub-3940256099942544/1712485313" // Test Ad Unit ID
        GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] (ad, error) in
            if let error = error {
                print("Failed to load rewarded ad: \(error.localizedDescription)")
                self?.adLoaded = false
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.adLoaded = true
            print("Rewarded ad loaded")
        }
    }

    func showAd(from rootViewController: UIViewController) {
        guard let ad = rewardedAd else {
            print("Ad wasn't ready")
            return
        }
        ad.present(fromRootViewController: rootViewController) { [weak self] in
            // User earned the reward
            let reward = ad.adReward
            print("User earned reward of \(reward.amount) \(reward.type)")
            self?.userDidEarnReward = true
        }
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present full screen content: \(error.localizedDescription)")
        loadAd()
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad dismissed full screen content")
        
        loadAd()
    }
}

