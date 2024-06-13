//
//  InterstetialAdView.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 08/06/24.
//
import SwiftUI
import GoogleMobileAds

struct InterstitialAdView: UIViewControllerRepresentable {
    @ObservedObject var adManager: InterstitialAdsManager
    
    class Coordinator: NSObject, GADFullScreenContentDelegate {
        var parent: InterstitialAdView
        var viewController: UIViewController?
        
        init(parent: InterstitialAdView) {
            self.parent = parent
        }
        
        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            print("Ad was dismissed.")
            viewController?.dismiss(animated: true, completion: nil)
            parent.adManager.onAdDismissed?()
        }
        
        func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
            print("Ad failed to present with error: \(error.localizedDescription)")
            viewController?.dismiss(animated: true, completion: nil)
            parent.adManager.onAdDismissed?()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        viewController.modalPresentationStyle = .overFullScreen
        
        context.coordinator.viewController = viewController
        
        if let ad = adManager.interstitialAd {
            ad.fullScreenContentDelegate = context.coordinator
            DispatchQueue.main.async {
                ad.present(fromRootViewController: viewController)
            }
        } else {
            print("Ad wasn't ready")
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update anything here
    }
}

