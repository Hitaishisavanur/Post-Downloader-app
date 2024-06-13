//
//  RewardedAdView.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 08/06/24.
//

import Foundation
import SwiftUI
import UIKit

struct RewardedAdViewControllerRepresentable: UIViewControllerRepresentable {
    @ObservedObject var adManager: RewardedAdManager

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            if self.adManager.adLoaded {
                self.adManager.showAd(from: viewController)
            }
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No update needed
    }
}

