//
//  newTrialApp.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 14/04/24.
//

import SwiftUI

@main
struct newTrialApp: App {
    let dataController = DataController.shared
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            BottomTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}
