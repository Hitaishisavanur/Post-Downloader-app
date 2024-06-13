

import SwiftUI
import RevenueCat
import UserNotifications

struct PremiumAdPopup: View {
    
    @State var showBottomsheet: Bool = false
    
     
    /// - State for displaying an overlay view
    @State
    private(set) var isPurchasing: Bool = false
    
    /// - The current offering saved from PurchasesDelegateHandler
    private(set) var currentOffering: Offering? = UserViewModel.shared.offerings?.current
    @State var selectedOption: Package?  // private let footerText = "Don't forget to add your subscription terms and conditions. Read more about this here: //https://www.revenuecat.com/blog/schedule-2-section-3-8-b"
    
    @State private var error: NSError?
    @State private var displayError: Bool = false
    
    var body: some View {
        VStack {
            ScrollView{
                
                VStack{
                    VStack{
                        Text("How your free")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("trial works")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }.padding(.top,30)
                        .padding(.bottom,25)
                    VStack(alignment: .leading){
                        HStack{
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
                                Text("Get Ad-Free experience with unlimited downloads, bookmarks and collection creations")
                                    .font(.subheadline)
                                
                                
                            }
                        }.padding(.bottom,15)
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
                        
                    }.padding(.bottom,20)
                    Divider()
                    
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
                                    Text("First 1 week free, then \(pkg.storeProduct.localizedPriceString )")}
                            }
                        }
                    }
                    
                    
                }
                VStack{
                    
                    Button{
                       
                        isPurchasing = true
                        Task{
                            /// - Purchase a package
                            
                            do {
                                if(selectedOption != nil){}else{selectedOption = currentOffering?.package(identifier: "$rc_annual")}
                                    let result = try await Purchases.shared.purchase(package: selectedOption!)
                                    
                                    /// - Set 'isPurchasing' state to `false`
                                    self.isPurchasing = false
                              
                                    if !result.userCancelled {
                                        self.showBottomsheet = false
                                        let customerInfoNotification = try await Purchases.shared.customerInfo()
                                        if let entitlement = customerInfoNotification.entitlements.all["pro"], entitlement.isActive {
                                            if selectedOption == currentOffering?.package(identifier: "$rc_annual"){
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
                label:{if currentOffering != nil{
                    
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
                        }else{
                            Text("Select Subscription")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(7)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            
                        }
                    }}else{
                    ProgressView()
                            .font(.title2)
                            .tint(.primary)
                            .padding(7)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                        
                }.buttonStyle(BorderedProminentButtonStyle())
                        
                    
                }
                VStack{
                    HStack{
                        VStack{
                            Button{showBottomsheet.toggle()}label:{Text("All plans")}
                        }
                        VStack{Text(".")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.bottom)
                        }
                        VStack{
                            HStack{
                                Button{}label:{Text("Restore")}}
                            HStack{
                                Button{}label:{Text("purchases")}}
                            
                        }
                        VStack{Text(".")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.bottom)
                        }
                        VStack{
                            VStack{
                                HStack{
                                    Button{}label:{Text("Terms and")}}
                                HStack{
                                    Button{}label:{Text("conditions")}}
                                
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
                                    Button{}label:{Text("Privacy")}}
                                HStack{
                                    Button{}label:{Text("policy")}}
                                
                            }
                        }
                    }.font(.footnote)
                } //.foregroundColor(.black)
            }.padding(.horizontal,20)
                .padding(.top,10)
            
        
        }.onAppear{
            selectedOption = currentOffering?.annual
        }
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
                    Text(package.storeProduct.localizedTitle)
                        .font(.headline)
                }
                Spacer()
                VStack{
                    Text(package.storeProduct.localizedPriceString)
                }
            }
            HStack{
                Text(package.storeProduct.localizedDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            
        }
        .padding()
        //.cornerRadius(10)
        
        
        //.border(isSelected ? Color.blue : Color.secondary.opacity(0.5), width: 3)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2.5).foregroundColor(isSelected ? Color.blue : Color.secondary.opacity(0.5)))
        
    }
}

//#Preview {
//    PremiumAdPopup(viewModel: BuyProViewModel())
//}
