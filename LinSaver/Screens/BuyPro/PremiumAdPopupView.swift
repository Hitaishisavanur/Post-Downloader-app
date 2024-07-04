

import SwiftUI
import RevenueCat
import UserNotifications

struct PremiumAdPopup: View {
    
    @State var showBottomsheet: Bool = false
    
    @StateObject var settingsViewModel = SettingsViewModel()
    @State private var trialEligibility: [String: IntroEligibility] = [:]    /// - State for displaying an overlay view
    @State
   // private(set)
    var isPurchasing: Bool = false
    @Environment(\.presentationMode) var presentationMode
    /// - The current offering saved from PurchasesDelegateHandler
    private(set) var currentOffering: Offering? = UserViewModel.shared.offerings?.current
    @State var selectedOption: Package?  // private let footerText = "Don't forget to add your subscription terms and conditions. Read more about this here: //https://www.revenuecat.com/blog/schedule-2-section-3-8-b"

    let crashlyticsManager = CrashlyticsManager.shared
    @State private var error: NSError?
    @State private var displayError: Bool = false
    @State var isNotEligibleForTrial = UserDefaults.standard.bool(forKey: "ineligible")
    
    var body: some View {
        VStack {
            HStack{
                VStack{}
                Spacer()
                VStack{
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    }label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            
                            .frame(width: 30,height: 30)
                            .padding()
                    }
                }
            }
            ScrollView{
                
                VStack{
                    VStack{
//                        if let eligibility = eligibility["LinSaver_0399_1y_1wO"]?.status, eligibility == .eligible {
                       // if trialEligibility["LinSaver_0399_1y_1wO"]?.status != .ineligible {
                        if !isNotEligibleForTrial{
                            Text("How your free")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Text("trial works")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }else{
                            Text("Get Premium!!")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                        }
                    }.padding(.top,30)
                        .padding(.bottom,25)
                    VStack(alignment: .leading){
                    
                        HStack{
//                            if let eligibility = eligibility["LinSaver_0399_1y_1wO"]?.status, eligibility == .eligible {
                           // if trialEligibility["LinSaver_0399_1y_1wO"]?.status != .ineligible {
                            if !isNotEligibleForTrial{
                            VStack{
                                Image(systemName: "lock.fill")
                                
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                    .frame(width: 35,height:35)
                                    .padding(4)
                            }
                                VStack(alignment: .leading){
                                    Text("Today")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    VStack(alignment: .leading){
                                        
                                        Text("Get Ad-Free experience.")
                                            .fontWeight(.bold)
                                        Text("Get unlimited downloads, bookmarks and collection creations.")
                                            .fontWeight(.bold)
                                        Text("Directly download and save to photos.")
                                            .fontWeight(.bold)
                                    }.font(.subheadline)
                                    
                                    
                                }
                                
                            }else{
                                
                                    VStack(alignment: .leading){
//                                        Text("Today")
//                                            .font(.title2)
//                                            .fontWeight(.semibold)
                                        VStack(alignment: .leading){
                                            HStack{
                                                VStack(alignment: .leading){
                                                    Image(systemName: "star.fill")
                                                    
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .foregroundColor(.accent)
                                                        .frame(width: 35,height:35)
                                                        .padding(4)
                                                }
                                                VStack{
                                                    Text("Get Ad-Free experience.")
                                                        .padding(.leading,10)
                                                }
                                            }
                                            
                                                
                                            HStack{
                                                VStack(alignment: .leading){
                                                    Image(systemName: "star.fill")
                                                    
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .foregroundColor(.accent)
                                                        .frame(width: 35,height:35)
                                                        .padding(4)
                                                }
                                                VStack{
                                                    Text("Get unlimited downloads, bookmarks and collection creations.")
                                                        .padding(.leading,10)
                                                        }
                                            }

                                            HStack{
                                                VStack(alignment: .leading){
                                                    Image(systemName: "star.fill")
                                                    
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .foregroundColor(.accent)
                                                        .frame(width: 35,height:35)
                                                        .padding(4)
                                                }
                                                VStack{
                                                    Text("Directly download and save to photos.")
                                                        .padding(.leading,10)
                                                        }
                                            }
                                        }.font(.title2)
                                        
                                        
                                    }
                                                                }
                        }.padding(.bottom,15)
              //          if let eligibility = eligibility["LinSaver_0399_1y_1wO"]?.status, eligibility == .eligible {
               //         if trialEligibility["LinSaver_0399_1y_1wO"]?.status != .ineligible {
                        if !isNotEligibleForTrial{
                            HStack{
                                VStack{
                                    Image(systemName: "bell.badge.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                        .frame(width: 35,height:35)
                                        .padding(4)
                                }
                                VStack(alignment: .leading){
                                    Text("Day 5")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text("You will get a notification that your trial is ending")
                                        .font(.subheadline)
                                    
                                    
                                }
                            }.padding(.bottom,15)
                            HStack{
                                VStack{
                                    Image(systemName: "checkmark.seal.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.green)
                                        .frame(width: 35,height:35)
                                        .padding(4)
                                }
                                VStack(alignment: .leading){
                                    Text("Day 7")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text("Your subscription starts, cancel anytime before")
                                        .font(.subheadline)
                                    
                                }
                            }
                        }
                        
                    }.padding(.bottom,20)
                    Divider()
                    VStack(alignment:.leading){
                        Text("Auto-Renews,Free trial for first purchase only")
                            .font(.caption)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    VStack(alignment:.leading){
                        Text("How can I cancel")
                            .font(.caption)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("It's easy: Open the app, tap settings and then select \"Manage Subscription\".\n You're in your AppStore subscriptions.\nSelect the app \"Cancel Trial\"and confirm")
                            .font(.caption)
                    }.padding(.horizontal,15)
                        .padding(.top,30)
                    
                    
                }.padding(20)
                
            }.onTapGesture {
                if(showBottomsheet){
                    showBottomsheet = false
                }
            }
            Spacer()
            VStack{
                if currentOffering != nil{
                    ForEach(currentOffering!.availablePackages){ pkg in
                        
                        VStack{
                            
                            if (showBottomsheet){
                                VStack(alignment: .leading) {
                                    
                                    Button(action: {
                                        selectedOption = pkg
                                    }) {
                                        PackageView(package: pkg, isSelected: selectedOption == pkg)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }//.padding()
                            
                            
                            else{
                                if (pkg.storeProduct.productIdentifier ==  "LinSaver_0399_1y_1wO" ){
                                   // if let eligibility = eligibility["LinSaver_0399_1y_1wO"]?.status, eligibility == .eligible {
                                 //   if trialEligibility["LinSaver_0399_1y_1wO"]?.status != .ineligible {
                                    if !isNotEligibleForTrial{
                                        Text("First 1 week free, then \(pkg.storeProduct.localizedPriceString )/year")
                                    }else{
                                        Text("Buy Pro at \(pkg.storeProduct.localizedPriceString )/year, Auto-Renews")
                                    }
                                }
                            }
                        }
                    }
                    
                    
                }
                VStack{
                    if currentOffering != nil{
                        Button{
                            purchaseButton()
                            
                        }
                    label:{
                  //      if let eligibility = eligibility["LinSaver_0399_1y_1wO"]?.status, eligibility == .eligible {
                    //    if trialEligibility["LinSaver_0399_1y_1wO"]?.status != .ineligible {
                        if !isNotEligibleForTrial{
                            if showBottomsheet == false{Text("Start Free Trial")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(7)
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            }else{
                                if ((selectedOption?.storeProduct.productIdentifier) != "LinSaver_0399_1y_1wO") && (selectedOption != nil) {Text("Continue")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(7)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                }else if((selectedOption?.storeProduct.productIdentifier) == "LinSaver_0399_1y_1wO"){
                                    Text("Start Free Trial")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(7)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                }
                            }
                        }else{
                            if showBottomsheet == false{Text("Subscribe")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(7)
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            }else{
                                if ((selectedOption?.storeProduct.productIdentifier) != "LinSaver_0399_1y_1wO") && (selectedOption != nil) {Text("Continue")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(7)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                }else if((selectedOption?.storeProduct.productIdentifier) == "LinSaver_0399_1y_1wO"){
                                    Text("Subscribe")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(7)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                }
                            }                        }
                    }
                    .tint(.accent)
                    .buttonStyle(BorderedProminentButtonStyle())
                    }else{
                        Button{
                            purchaseButton()
                            
                        }
                    label:{
                        ProgressView()
                            .font(.title2)
                            .tint(.primary)
                            .padding(7)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                            .disabled(true)
                        
                    }
                    
                    
                }
                VStack{
                    HStack{
                        VStack{
                            if(currentOffering != nil){
                                Button{
                                    
                                    selectedOption = currentOffering?.annual
                                    showBottomsheet.toggle()
                                }
                                
                            label:{Text("All plans")}
                            }
                            else{
                                Button{
                                    
                                    selectedOption = currentOffering?.annual
                                    showBottomsheet.toggle()
                                }
                                
                            label:{Text("All plans")}
                                    .disabled(true)
                            }
                                   
                        }
                        VStack{Text(".")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.bottom)
                        }
                        VStack{
                            HStack{
                                Text("Restore")}
                            HStack{
                                Text("purchases")}
                            
                        } .foregroundStyle(.blue)
                            .onTapGesture {
                               
                                settingsViewModel.restorePurchase()
                            }
                        VStack{Text(".")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.bottom)
                        }
                        VStack{
                            VStack{
                                HStack{
                                    Text("Terms")}
                                HStack{
                                    Text("of use")}
                                
                            } .foregroundStyle(.blue)
                                .onTapGesture {
                                    settingsViewModel.showTermsOfUse()
                                }
                        }
                        VStack{Text(".")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.bottom)
                        }
                        VStack{
                            VStack{
                                HStack{
                                    Text("Privacy")}
                                HStack{
                                    Text("policy")}
                                
                            }
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                settingsViewModel.showPrivacyPolicy()
                            }
                        }
                    }.font(.footnote)
                } //.foregroundColor(.black)
            }.padding(.horizontal,20)
                .padding(.top,10)
                
            
        }
               
            
        .onAppear{
            checkEligibility()
            selectedOption = currentOffering?.annual
            
                
            
        }
        .restorePurchaseAlert(isPresented: $settingsViewModel.showError, alertText: settingsViewModel.errorMessage, onDismiss: onDismissError)
        .loadingOverlay(isPresented: $settingsViewModel.isPurchasing, loadingText: "Restoring Purchases, Please wait")
        .loadingOverlay(isPresented: $isPurchasing, loadingText: "Loading, Please wait")
    }
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                crashlyticsManager.addLog(message: error.localizedDescription)
            }
            if granted {
            } else {
            }
        }
    }
    func purchaseButton(){
        isPurchasing = true
        Task{
            /// - Purchase a package
            
            do {
                if(selectedOption != nil){}else{selectedOption = currentOffering?.package(identifier: "$rc_annual")}
                if(selectedOption == currentOffering?.package(identifier: "$rc_annual")){
                    requestNotificationPermission()
                }
                let result = try await Purchases.shared.purchase(package: selectedOption!)
                
                /// - Set 'isPurchasing' state to `false`
                self.isPurchasing = false
                
                if !result.userCancelled {
                    self.showBottomsheet = false
                    let customerInfoNotification = try await Purchases.shared.customerInfo()
                    if let entitlement = customerInfoNotification.entitlements.all["pro"], entitlement.isActive {
                        if selectedOption == currentOffering?.package(identifier: "$rc_annual") && (entitlement.periodType == .intro || entitlement.periodType == .trial)   {
                            UserDefaults.standard.set(true, forKey: "ineligible")
                            UserViewModel().addSubscription()
                            
                        }
                    }
                }
            } catch {
                self.isPurchasing = false
                self.error = error as NSError
                self.displayError = true
            }
        }
        
    }
    
    func checkEligibility() {
        guard let offering = currentOffering else { return }
//        let productIdentifiers = offering.availablePackages.map { $0.storeProduct.productIdentifier }
        Purchases.shared.checkTrialOrIntroDiscountEligibility(productIdentifiers: ["LinSaver_0399_1y_1wO"]){ eligibility in
            self.trialEligibility = eligibility
        }
    }
    func onDismissError(){
        settingsViewModel.showError = false
    }

}

struct PackageView: View {
    let package: Package
    let isSelected: Bool
    
    var body: some View {
        VStack{
            HStack {
                VStack{
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                VStack(alignment: .leading) {
                    Text(package.storeProduct.productIdentifier ==  "LinSaver_0399_1y_1wO" ? "Yearly Subscription" : "Monthly Subscription")
                        .font(.headline)
                }
                Spacer()
                VStack{
                    Text(package.storeProduct.localizedPriceString)
                                        }
            }
            HStack{
                VStack(alignment: .leading){
                    Text(package.storeProduct.productIdentifier ==  "LinSaver_0399_1y_1wO" ? "First 1 week free,then \(package.storeProduct.localizedPriceString)/yr" : "Full Access for just \(package.storeProduct.localizedPriceString)/mo")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                      
                }
            }
            
            
        }
        .padding()
       
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2.5).foregroundColor(isSelected ? Color.blue : Color.secondary.opacity(0.5)))
        
    }
}

//#Preview {
//    PremiumAdPopup(viewModel: BuyProViewModel())
//}
