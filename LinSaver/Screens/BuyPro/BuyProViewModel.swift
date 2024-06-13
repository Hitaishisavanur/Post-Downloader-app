//
//  BuyProViewModel.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 08/05/24.
//

import Foundation


class BuyProViewModel: ObservableObject {
    
    @Published var selectedOption: Int = 0
    
    let packages = [
        ProPackage(name: "Weekly Package", pricePerWeek: "$2.99 per week", totalPrice: "$2.99"),
        ProPackage(name: "Yearly Package", pricePerWeek: "$20.81 per week", totalPrice: "$999.00"),
        ProPackage(name: "Lifetime Package", pricePerWeek: "", totalPrice: "$2999.00")
    ]
    
    func subscribe() {
        print("Subscribe now")
    }
}
