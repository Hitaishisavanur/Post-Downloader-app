//
//  SwiftUIView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 08/05/24.
//

import SwiftUI

struct PremiumAdPopup: View {
    @ObservedObject var viewModel: BuyProViewModel
    
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
                
            }
            Spacer()
            VStack{
                VStack{
                    Text("First 1 week free, then \(viewModel.packages[1].totalPrice)/yr")
                }
                VStack{
                    Button{print("Start Trial")}
                label:{Text("Start Free Trial")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(7)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }.buttonStyle(BorderedProminentButtonStyle())
                
                    
                }
                HStack{
                    VStack{
                        Button{}label:{Text("All plans")}
                    }
                    VStack{Text(".")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.bottom)
                    }
                    VStack{
                        Button{}label:{Text("Restore purchases")}
                    }
                    VStack{Text(".")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.bottom)
                    }
                    VStack{
                        Button{}label:{Text("Terms and conditions")}
                    }
                    VStack{Text(".")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.bottom)
                    }
                    VStack{
                        Button{}label:{Text("Privacy policy")}
                    }
                }.font(.footnote)
                    .foregroundColor(.black)
            }.padding(.horizontal,20)
                .padding(.top,10)
                
        }
    }
}

#Preview {
    PremiumAdPopup(viewModel: BuyProViewModel())
}
