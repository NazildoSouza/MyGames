//
//  FilteredList.swift
//  MyGames
//
//  Created by Nazildo Souza on 12/05/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct FilteredList: View {
    @ObservedObject var data = GamesData()
    @Environment(\.managedObjectContext) var moc
    var fetchRequest: FetchRequest<Game>
    
    init(filter: String) {
        fetchRequest = FetchRequest<Game>(
            entity: Game.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Game.title, ascending: true)],
            predicate: NSPredicate(format: "title CONTAINS [c] %@", filter)
    )}
    
    func dateFormatted(date: Date) -> String {
        let formatt = DateFormatter()
        formatt.dateStyle = .long
        return formatt.string(from: date)
    }
    
    var body: some View {
        List {
            if self.fetchRequest.wrappedValue.count != 0 {
            ForEach(fetchRequest.wrappedValue, id: \.self) { game in
                NavigationLink(destination: GameView(game: game, data: self.data)) {
                    HStack(alignment: .top) {
                        if game.cover != nil {
                            Image(uiImage: UIImage(data: game.cover!)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 100)
                            .cornerRadius(15)
                        } else {
                            Image("noCoverFull")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 100)
                            .cornerRadius(15)
                        }

                        VStack(alignment: .leading) {
                            Text(game.title ?? "Sem Titulo")
                                .font(.title)
                                .fontWeight(.heavy)
                            Text(game.console?.name ?? "console desconhecido")
                                .font(.subheadline)
                                .fontWeight(.medium)

                            Text(self.dateFormatted(date: game.releaseDate ?? Date()))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 8)

                        }
                        .padding(.leading, 5)
                    }
                }
            }
            .onDelete { index in
                let game = self.fetchRequest.wrappedValue[index.first!]
                self.moc.delete(game)
                if self.moc.hasChanges {
                    try? self.moc.save()
                }
            }
            
            } else {
                HStack {
                    Spacer()
                        Text("Sem resultados")
                        .font(.headline)
                    Spacer()
                }
            }
        }
    }
}
