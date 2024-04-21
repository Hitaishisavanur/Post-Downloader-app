//
//  SwiftUIView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 15/04/24.
//

import SwiftUI

struct BottomTabView: View {
    var body: some View {
                
        TabView{
            
            HomeScreenView()
                .tabItem { Label("Home", systemImage: "house")
                }
            
            SavedFilesView()
                .tabItem { Label("Saved Files", systemImage: "rectangle.stack")
                }
            
            BookmarkView()
                .tabItem { Label("Bookmarks", systemImage: "bookmark")
                }
            
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape")
                }
            
               
        }
        
        
        
        
        
            
    }
}

#Preview {
    BottomTabView()
}
