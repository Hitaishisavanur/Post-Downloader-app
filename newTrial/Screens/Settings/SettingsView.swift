//
//  SettingsView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 15/04/24.
//

import SwiftUI


struct SettingsView: View {
    @State var saveToPhotos = false
    
    var version = "1.01"
    
    var body: some View {
        
        
        NavigationView{
            Form{
                Section{
                    Text("Try Ad-free Subscription")
                        .onTapGesture(perform: {
                            print("hello")
                        })
                    
                    Text("Restore Purchase")
                        .onTapGesture(perform: {
                            print("hello")
                        })
                    
                    Text("About Subscription")
                        .onTapGesture(perform: {
                            print("hello")
                        })
                    
                    Text("Manage Subscription")
                        .onTapGesture(perform: {
                            print("hello")
                        })
                    
                    Toggle("Save to Camera Roll", isOn: self.$saveToPhotos)
                    
                }
                
                Section{
                    Text("Share App")
                        .onTapGesture(perform: {
                        print("hello")
                    })
                    
                    Text("Rate on the App Store")
                        .onTapGesture(perform: {
                        print("hello")
                    })
                }
                
                Section{
                    Text("FAQ")
                        .onTapGesture(perform: {
                            print("hello")
                        })
                    
                    Text("Contact Us")
                        .onTapGesture(perform: {
                            print("hello")
                        })
                    
                    Text("Send Feedback")
                        .onTapGesture(perform: {
                        print("hello")
                    })
                }
                
                Section{
                    Text("Privacy Policy")
                        .onTapGesture(perform: {
                        print("hello")
                    })
                    
                    Text("Terms of Use")
                        .onTapGesture(perform: {
                        print("hello")
                    })
                }
                
                Section{
                    Text("About")
                        .onTapGesture(perform: {
                            print("hello")
                        })
                }
                
            }
            
            .navigationTitle(Text("Settings"))
        }
        
    }
}

#Preview {
    SettingsView()
}
