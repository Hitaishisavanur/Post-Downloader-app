//
//  HomeScreenView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 15/04/24.
//

import SwiftUI

struct HomeScreenView: View {
    @State var text = ""
    @State var saveToPhotos = false
    var body: some View {
        
            NavigationView{
                
                Form{
                    VStack{
                        Text("Paste Test Link")
                            .font(.headline)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding(20) 
                        .padding(.top, 30)
                    }.listRowSeparator(.hidden)
                    HStack{
                        
                        VStack{
                            Section{
                                TextField( "test link...", text: $text )
                                    .padding(8)
                            }
                        }
                        
                        VStack{
                            Section{
                                
                                Button{ print("pasted")}
                            label: {
                                Text("Paste")
                                
                            }.buttonStyle(.borderedProminent)
                                
                                
                            }
                            
                        }
                    }.padding(7)
                    
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                    VStack{
                        
                        
                        Button{print("downloading")}
                    label: {
                        
                        
                        Text("Download")
                            .font(.title2)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }.buttonStyle(.borderedProminent)
                        
                        Spacer()
                        VStack{
                            Toggle(isOn: $saveToPhotos, label: {
                                Text("Save a Copy to Photos")
                            }).padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                        }.padding(.top, 40)
                    }
                    
                    
                }.padding(.top,30)
                    
                    
                
                    .navigationTitle(Text("Downloader"))
                
                    .toolbar{
                        
                        NavigationLink(destination: BuyProView()) {
                            
                            Text("Ads-Free")
                                .font(.headline)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                .padding()
                                .foregroundColor(.primary)
                                
                            
                            
                        }
                        .frame(width: 100, height: 40)
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary, lineWidth: 2)
                            
                    ).padding(.trailing, 2)
                        
                    }
                
            }
        
    }
}

#Preview {
    HomeScreenView()
}
