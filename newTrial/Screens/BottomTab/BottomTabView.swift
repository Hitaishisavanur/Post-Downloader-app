//
//  SwiftUIView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 15/04/24.
//

import SwiftUI

struct BottomTabView: View {
    var body: some View {
        ZStack {
        
            TabView{
                
                
                HomeScreenView(viewModel: HomeScreenViewModel())
                    .tabItem { Label("Home", systemImage: "house")
                    }
                
                
                CollectionsView(viewModel: CollectionsViewModel())
                    .tabItem { Label("Collections", systemImage: "rectangle.stack")
                    }
                
                BookmarkView()
                    .tabItem { Label("Bookmarks", systemImage: "bookmark")
                    }
                
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape")
                    }
                }
        }.background(.ultraThinMaterial)
            
    }
}

#Preview {
    BottomTabView()
}

