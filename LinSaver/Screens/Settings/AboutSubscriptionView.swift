//
//  AboutSubscriptionView.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 18/06/24.
//

import SwiftUI
import RevenueCat

struct AboutSubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    private var userViewModel = UserViewModel.shared
    @StateObject var viewModel = SettingsViewModel()
    private(set) var currentOffering: Offering? = UserViewModel.shared.offerings?.current
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                Text("""
        We currently offer the following auto-renewing subscriptions:
            • Yearly Subscription: \(currentOffering!.package(identifier: "$rc_annual")!.localizedPriceString)/year.
            • Monthly Subscription: \(currentOffering!.package(identifier: "$rc_monthly")!.localizedPriceString)/month.
        By subscribing, get unlimited access to our PinSaver- Save Pinterest Video.
        
        The payment will be charged to your iTunes Account within 24 hours prior to the end of the free trial period - if applicable - or at the confirmation of your purchase.
        
        Your subscription automatically renews unless auto-renewal is turned off at least 24-hours before the end of the current period. You can cancel auto-renewal at any time, but this won't affect the currently active subscription period.
        Your iTunes Account will be charged for renewal within 24-hours prior to the end of the current period.
        You can manage your subscriptions and turn off auto-renewal by going to your Account Settings after the purchase and following these steps:
        
            1 Go to Settings app from the main menu on your iPhone.
            2 Tap on your name.
            3 Tap on Subscriptions to see the list of active subscriptions.
            4 Find your PinSaver subscriptions and tap on it.
            5 Select your active subscription and tap on Cancel subscription.
        Any unused portion of a free trial period, will be forfeited if you purchase a subscription to that publication.
        
        We take the satisfaction and security of our customers very seriously. Please take a look at our terms of use and privacy policy linked below.
        """)
                Text("Terms of Use")
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        viewModel.showTermsOfUse()
                        
                    }
                        Text("Privacy Policy")
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                viewModel.showPrivacyPolicy()
                            }
                    }.padding()
                    .navigationTitle("Subscription Info")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        
                        trailing:
                            Button{
                                presentationMode.wrappedValue.dismiss()
                                viewModel.showAboutSubscription = false
                            } label: {
                                Text("Done")
                            }
                        
                    )
            
            
            
        }.navigationViewStyle(.stack)
    }
}

#Preview {
    AboutSubscriptionView()
}
