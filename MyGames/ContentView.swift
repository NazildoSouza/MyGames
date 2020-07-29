//
//  ContentView.swift
//  MyGames
//
//  Created by Nazildo Souza on 09/05/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var data = GamesData()
    
    var body: some View {
        TabView {
            GameList(data: self.data)
                .tabItem {
                    Image(systemName: "gamecontroller")
                        .font(.title)
                        .padding()
                    Text("Game")
                        .imageScale(.large)
            }
            
            ConsoleList(data: self.data)
                .tabItem {
                    Image(systemName: "tray")
                        .font(.title)
                        .padding()
                    Text("Console")
                        .imageScale(.large)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
