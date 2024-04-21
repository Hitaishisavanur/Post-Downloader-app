//
//  BuyProView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 16/04/24.
//

import SwiftUI

struct BuyProView: View {
    @State private var selectedOption: Int = 0
    let options = [("Yearly Package", "$20.81 per week", "$999.00"), ("Weekly Package", "$2.99 per week", "$2.99"), ("Lifetime Package", "", "$2999.00")]
    
    var body: some View {
        
        ZStack{LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.5), Color.black.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack{
                VStack {
                    Text("Unlock Unlimited Access")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                }.padding(.bottom,5)
                VStack{
                    HStack{
                        VStack{
                            Button{print("cancelled") }
                        label: {
                                Text("x")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }.frame(width: 35, height:35)
                                .background(.blue.opacity(0.2))
                                .cornerRadius(10)
                            
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.blue, lineWidth: 1)
//                                )
                        }.padding(.horizontal, 10)
                        Spacer()
                        VStack{
                            Button{print("Restored")}label: {
                                Text("Restore")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    
                            }.padding(5)
                                .background(.blue.opacity(0.2))
                                .cornerRadius(10)
                            
                               // .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.blue, lineWidth: 1)
//                                )
                                
                        }.padding(.horizontal, 10)
                    }
                    VStack(alignment: .leading)
                    {
                        HStack {
                            Text(Image(systemName: "checkmark.seal")) + Text(" Unlock All Features")
                        }.padding(.bottom,10)
                            .foregroundColor(.white)
                            
                       HStack {
                            Text(Image(systemName: "checkmark.seal")) + Text(" Unlimited Saving")
                       }.padding(.bottom,10)
                            .foregroundColor(.white)
                        
                       HStack {
                            Text(Image(systemName: "checkmark.seal")) + Text(" 100% Secure")
                       }.padding(.bottom,10)
                            .foregroundColor(.white)
                        
                        HStack{
                            Text(Image(systemName: "checkmark.seal")) + Text(" No Ads")
                        }.foregroundColor(.white)
                            .padding(.bottom,10)
                            
                        
                    }.padding(.top,10)
                        .padding(.bottom,20)
                    VStack(alignment: .leading) {
                               ForEach(0 ..< options.count) { index in
                                   Button(action: {
                                       self.selectedOption = index
                                   }) {
                                       HStack {
                                           Image(systemName: self.selectedOption == index ? "checkmark.circle.fill" : "circle")
                                                                       .resizable()
                                                                       .frame(width: 20, height: 20)
                                           VStack(alignment: .leading) {
                                               Text(self.options[index].0)
                                                   .font(.headline)
                                               Text(self.options[index].1)
                                                   .font(.subheadline)
                                                   .foregroundColor(.gray)
                                           }
                                           Spacer()
                                           Text(self.options[index].2)
                                       }
                                       .padding()
                                   }
                                   .background(self.selectedOption == index ? Color.blue.opacity(0.2) : Color.clear)
                                   .cornerRadius(10)
                                   .padding(.vertical, 5)
                               }
                               .padding(.horizontal)
                        
                        
//                               
//                               Text("Selected Option: \(options[selectedOption].0)")
//                                   .padding()
//                               Text("Price: \(options[selectedOption].2)")
//                                   .padding()
                           }
                           .padding()
                           .onAppear {
                               self.selectedOption = 0 // Default selected option is Yearly Package
                           }.padding()
                    VStack {
                        Button{
                            print("Subscribe now")
                        }label:{
                            Text("Subscribe Now")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            
                        }.buttonStyle(.borderedProminent)
                            .padding(.horizontal,40)
                            .padding(.bottom, 10)
                        
                        Text("Auto-renewable. Cancel anytime.")
                            .foregroundColor(.init(white: 0.75))
                            .font(.title3)
                        
                        
                    }
                        
                       
                    
                    
                }
                Spacer()
            }//Vstack
            
            
            
                
            
        }.navigationBarBackButtonHidden(true)
    }
}
    
    
struct BuyProView_Previews: PreviewProvider {
        static var previews: some View {
            BuyProView()
        }
    }

