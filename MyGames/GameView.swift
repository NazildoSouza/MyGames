//
//  GameView.swift
//  MyGames
//
//  Created by Nazildo Souza on 10/05/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct GameView: View {
    var game: Game
    @ObservedObject var data: GamesData
    
    var dateFormatted: String {
        let formatt = DateFormatter()
        formatt.dateStyle = .long
        return formatt.string(from: self.game.releaseDate ?? Date())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.title ?? "Sem Titulo")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding([.horizontal, .top])
            
            Text(game.console?.name ?? "Console Desconhecido")
                .font(.headline)
                .padding(.horizontal)
            
            Text("Data de lançamento:\n\(dateFormatted)")
                .font(.headline)
                .padding()
            
            if game.cover != nil {
                Image(uiImage: UIImage(data: game.cover!)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
            } else {
                Image("noCoverFull")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(game.title ?? "Sem titulo"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.data.tempGame = self.game
            self.data.addOurEdit = 1
            self.data.title = self.game.title ?? ""
            self.data.date = self.game.releaseDate ?? Date()
            self.data.imageCover = self.game.cover
            self.data.indice = self.game.console ?? Console()
            
            self.data.showingAddGame.toggle()
            
        }, label: {
            Text("Edite")
        }))
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game(), data: GamesData())
    }
}
